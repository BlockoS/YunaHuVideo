/*
 * HuVideo decoder for Ginga Ojousama Densetsu Yuna HuVIDEO CD and Kuusou Kagaku Sekai Gulliver Boy
 * Licensed under Public Domain
 * No warranty implied
 * Use at your own risk
 * 2020 - Vincent Cruz
 */
#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <getopt.h>
#include <errno.h>
#include <sys/stat.h>
#include <sys/types.h>

#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb_image_write.h"

static uint32_t g_sector_size = 0x0930; // redump is using mode1, so sectors are 2352 bytes long.
static uint32_t g_adpcm_size = 800;

enum HuVideoFormat {
    BG = 0,
    SPR
};

struct header_t {
    uint16_t frames;
    uint16_t width;
    uint16_t height;
    uint8_t flag;
    uint8_t format;
    uint16_t adpcm_len;
    uint16_t unknown[3];
};

// Convert PCE tile vram data to RGB8.
void tile_to_rgb8(uint8_t *rgb, uint8_t *vram, uint8_t *tile, uint8_t *palette, struct header_t *header) {
    uint16_t tile_w = header->width / 8;
    uint16_t tile_h = header->height / 8;
    uint32_t rgb_line_stride = header->width * 3;
    uint32_t pal = 0;

    for(int j=0; j<tile_h; j++) {
        for(int i=0; i<tile_w; i++) {
            uint8_t *pce_tile = vram + (i + j*tile_w) * 32;
            uint8_t *out_tile = rgb + (i + j*header->width) * 8 * 3;
            if(i&1) {
                pal = (tile[0] & 0x0f) << 4;
                ++tile;
            }
            else {
                pal = (tile[0] & 0xf0);
            }
            for(int y=0; y<8; y++, pce_tile+=2, out_tile+=rgb_line_stride) {
                uint8_t b0 = pce_tile[0];
                uint8_t b1 = pce_tile[1];
                uint8_t b2 = pce_tile[16];
                uint8_t b3 = pce_tile[17];

                uint8_t *out = out_tile + 7*3;
                for(int x=0; x<8; x++, out-=3) {
                    uint8_t index = pal + ((b0&1) | ((b1&1)<<1) | ((b2&1)<<2) | ((b3&1)<<3));
                    out[0] = palette[3*index];
                    out[1] = palette[3*index+1];
                    out[2] = palette[3*index+2];

                    b0 >>= 1;
                    b1 >>= 1;
                    b2 >>= 1;
                    b3 >>= 1;
                }
            }
        }
    }
}

// Convert PCE sprite vram data to RGB8 (only supports 32*64 sprite size).
void sprite_to_rgb8(uint8_t *rgb, uint8_t *vram, uint8_t *palette, struct header_t *header) {
    uint16_t sprite_w = header->width / 16;
    uint16_t sprite_h = header->height / 16;
    uint32_t rgb_line_stride = header->width * 3;

    for(int j=0; j<sprite_h; j++) {
        for(int i=0; i<sprite_w; i++) {
            uint16_t *pce_sprite = (uint16_t*)(vram + (i + j*sprite_w) * 0x80);
            
            int u = ((i & 1) * 16) + (j * 32);
            int v = (i >> 1) * 16;
            uint8_t *out_sprite = rgb + (u + v*header->width) * 3;
            for(int y=0; y<16; y++, pce_sprite+=1, out_sprite+=rgb_line_stride) {
                uint16_t w0 = pce_sprite[0];
                uint16_t w1 = pce_sprite[16];
                uint16_t w2 = pce_sprite[32];
                uint16_t w3 = pce_sprite[48];

                uint8_t *out = out_sprite + 15*3;
                for(int x=0; x<16; x++, out-=3) {
                    uint8_t index = (w0&1) | ((w1&1)<<1) | ((w2&1)<<2) | ((w3&1)<<3);
                    out[0] = palette[3*index];
                    out[1] = palette[3*index+1];
                    out[2] = palette[3*index+2];

                    w0 >>= 1;
                    w1 >>= 1;
                    w2 >>= 1;
                    w3 >>= 1;
                }
            }
        }
    }
}

// Read sectors.
// As we have mode1 sectors, we skip the first 16 bytes and read 2048 bytes of each sector.
int sector_read(uint8_t *buffer, size_t count, FILE *in) {
    size_t offset = ftell(in);
    size_t start = offset / g_sector_size;
    size_t i;

    start = 0x10 + (start * g_sector_size);

    for(i=0; i<count; i++, buffer+=2048, start+=g_sector_size) {
        if(fseek(in, start, SEEK_SET)) {
            fprintf(stderr, "Failed to set file pointer: %s.\n", strerror(errno));
            return EXIT_FAILURE;
        }
        if(fread(buffer, 1, 2048, in) != 2048) {
            fprintf(stderr, "Failed to read sector: %s.\n", strerror(errno));
            return EXIT_FAILURE;
        }
    }
    fseek(in, start, SEEK_SET);
    return EXIT_SUCCESS;
}

// Skip N sectors.
void sector_skip(size_t n, FILE *in) {
    size_t offset;
    size_t sector_id;
    offset = ftell(in);
    sector_id = offset / g_sector_size;
    fseek(in, (sector_id+n) * g_sector_size, SEEK_SET);
}

// Write the frame as a standard RGB8 image and append the adpcm data.
int write_frame(struct header_t *header, uint8_t *buffer, uint8_t *image, const char *prefix, int frame_id) {
    int ret = EXIT_SUCCESS;
    char filename[512];

    uint8_t *pce_tile_data = buffer;
    uint8_t *pce_palette = pce_tile_data + header->width*header->height*32/64;
    uint8_t *pce_tile_pal = pce_palette + 512;
    uint8_t *pce_adpcm = pce_tile_pal + header->width*header->height/64/2;

    uint8_t palette[256*3];

    size_t n_written;

    FILE *out;

    for(int i=0; i<256; i++) {
        palette[i*3  ] = 255 * ((pce_palette[2*i] >> 3) & 0x7) / 7;
        palette[i*3+1] = 255 * (((pce_palette[2*i] >> 6) & 0x07) | ((pce_palette[2*i+1] & 0x07) << 2)) / 7;
        palette[i*3+2] = 255 * (pce_palette[2*i] & 0x07) / 7;
    }

    sprintf(filename, "%s/%06d.png", prefix, frame_id);
    tile_to_rgb8(image, pce_tile_data, pce_tile_pal, palette, header);
    stbi_write_png(filename, header->width, header->height, 3, image, 0);

    sprintf(filename, "%s/sample.vox", prefix);
    out = fopen(filename, "ab");
    if(out == NULL) {
        fprintf(stderr, "Failed to open %s: %s\n", filename, strerror(errno));
        return EXIT_FAILURE;
    }
    n_written = fwrite(pce_adpcm, 1, g_adpcm_size, out);
    if(n_written != g_adpcm_size) {
        fprintf(stderr, "Failed to write %s: %s\n", filename, strerror(errno));
        ret = EXIT_FAILURE;
    }
    fclose(out);
    return ret;
}

/* This part is based upon the source code found in Power Golf 2 and Beyond Shadowgate. */
int decode_header(FILE *in, struct header_t *header) {
    static const char magic[16] = "HuVideo\0\0\0\0\0\0\0\0\0";
    
    size_t n_read;
    uint8_t buffer[16];

    n_read = fread(buffer, 1, 16, in);
    if(n_read != 16) {
        fprintf(stderr, "failed to read header ID.\n");
        return 0;
    }
    if(memcmp(buffer, magic, 16)) {
        fprintf(stderr, "invalid header ID.\n");
        return 0;
    }
    n_read = fread(&header->frames, 1, 2, in);
    if(n_read != 2) {
        fprintf(stderr, "failed to read frame count.\n");
        return 0;
    }
    n_read = fread(&header->width, 1, 2, in);
    if(n_read != 2) {
        fprintf(stderr, "failed to read frame width.\n");
        return 0;
    }
    if((header->width < 1) || (header->width >512)) {
        fprintf(stderr, "invalid frame width.\n");
        return 0;
    }
    n_read = fread(&header->height, 1, 2, in);
    if(n_read != 2) {
        fprintf(stderr, "failed to read frame height.\n");
        return 0;
    }
    if((header->height < 1) || (header->height >512)) {
        fprintf(stderr, "invalid frame height.\n");
        return 0;
    }
    n_read = fread(&header->flag, 1, 1, in);
    if(n_read != 1) {
        fprintf(stderr, "failed to read palette flag.\n");
        return 0;
    }
    n_read = fread(&header->format, 1, 1, in);
    if(n_read != 1) {
        fprintf(stderr, "failed to read format.\n");
        return 0;
    }
    if(header->format > 1) {
        fprintf(stderr, "invalid format.\n");
        return 0;
    }
    n_read = fread(&header->adpcm_len, 1, 2, in);
    if(n_read != 2) {
        fprintf(stderr, "failed to read adpcm length.\n");
        return 0;
    }
    // The next 6 bytes are unknown.
    n_read = fread(&header->unknown, 1, 6, in);
    if(n_read != 6) {
        fprintf(stderr, "failed to read the header end.\n");
        return 0;
    }

    printf(
        "frames: %d\n"
        "width : %d\n"
        "height: %d\n"
        "flag  : %0x\n"
        "format: %04x\n"
        "adpcm : %d\n"
        "unknown: %0x %0x %0x\n",
        header->frames,
        header->width,
        header->height,
        header->flag,
        header->format,
        header->adpcm_len,
        header->unknown[0],
        header->unknown[1],
        header->unknown[2]
    );
    return 1;
}

void usage() {
    fprintf(stderr, "huvideo_decode -o/--offset N in output_directory\n");
}

int main(int argc, char **argv) {
    int c;
    int option_index;

    const struct option options[] = {
        {"offset",  optional_argument, 0, 'o' },
        {0,         0,                 0,  0 }
    };

    FILE *in;
    size_t input_length;
    
    struct header_t header;
   
    int64_t i;
    int64_t count = 0;
    int64_t offset = -1; 

    int ret;

    for(;;) {
        c = getopt_long(argc, argv, "o:", options, &option_index);
        if(c < 0) {
            break;
        }
        switch(c) {
            case 'o':
                offset = strtoul(optarg, NULL, 16);
                break;
            default:
                usage();
                return EXIT_FAILURE;
        }
    }

    if((optind + 2) > argc) {
        usage();
        return EXIT_FAILURE;
    }

    in = fopen(argv[optind],"rb");
    if(in == NULL) {
        fprintf(stderr, "failed to open %s: %s\n", argv[optind], strerror(errno));
        return EXIT_FAILURE;
    }

    // Compute file size.
    fseek(in, 0, SEEK_END);
    input_length = ftell(in);
    fseek(in, 0, SEEK_SET);
    input_length -= ftell(in);

    if(offset >= 0) {
        count = 1;
    }
    else {
        count = input_length / g_sector_size;
    }

    const char *prefix = argv[optind+1];
    size_t str_len;
    char *str;

    // Allocate output filename buffer.
    str_len = strlen(prefix) + 32;
    str = (char*)malloc(str_len);

    ret = EXIT_SUCCESS;
    for(i=0; (i<count) && (ret != EXIT_FAILURE); i++) {
        uint8_t *buffer;
        uint8_t *image;
        size_t skip = (offset > 0) ? offset : ((i*g_sector_size) + 0x10);
        fseek(in, skip, SEEK_SET);

        // Read  Huvideo header.
        if(!decode_header(in, &header)) {
            continue;
        }

        // Create output directory.
        snprintf(str, str_len, "%s/%04ld", prefix, i);
        mkdir(str, 0755);

        // Create input and output buffers.
        buffer = (uint8_t*)malloc(header.adpcm_len * 2048);
        image = (uint8_t*)malloc(header.width * header.height * 3);

        // Read frames
        sector_skip(4, in);
        for(int j=0; j<header.frames; j++) {
            ret = sector_read(buffer, header.adpcm_len, in);
            if(ret == EXIT_FAILURE) {
                break;
            }
            write_frame(&header, buffer, image, str, j);
            if(ret == EXIT_FAILURE) {
                break;
            }
        }

        free(image);
        free(buffer);
    }

    free(str);

    return ret;
}
