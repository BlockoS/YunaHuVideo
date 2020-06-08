# HuVideo extractor for Ginga Ojousama Densetsu Yuna HuVIDEO CD / 銀河お嬢様伝説ユナ (HCD5078)
# and  Kuusou Kagaku Sekai Gulliver Boy / 空想科学世界ガリバーボーイ (HCD5076)

## Decoder

### How to build
You only have to compile `huvideo_decode.c` with your favorite C compiler.
```sh
gcc huvideo_decode.c -o huvideo_decode
```

### Usage
```sh
huvideo_decode -o 0x03739450 -g 0 <image> <output_prefix>
```
### Description
This program will extract all video frames and adpcm audio of a single HuVideo from a CDROM image and output them as PNG files and vox file (https://en.wikipedia.org/wiki/Dialogic_ADPCM).

The adpcm audio can be played or converted using `sox`.
```bash
play --rate 16k sample.vox
sox --rate 16k sample.vox sample.wav
```

### Parameters
 * `-o/--offset <hex>` (optional) specify the offset in byte in the image file.
 * `<image>` CDROM image.
 * `<output_prefix>` output files prefix.
 
## Decoder script

### Usage
```sh
decode.sh <decoder> <img>
```

### Description
`decode.sh` is a shell script that will extract all HuVideos and save them as MP4 (h264) using `ffmpeg`.
The CDROM image is expected to match the one from the `redump project`.

The result can be found here :
 * https://blockos.org/releases/pcengine/HuVideo/Yuna
 * http://blockos.org/releases/pcengine/HuVideo/Gulliver (⚠ spoilers)

### Parameters
 * `<decoder>` is the HuVideo decoder.
 * `<img>` is the CDROM image.
