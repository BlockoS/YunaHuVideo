#!/usr/bin/env sh
if [ ! -f "${1}" ] || [ ! -x "${1}" ]; then
    echo "${1} is not an executable file"
    exit 1
fi

if [ ! -f "${2}" ]; then 
    echo "${2} is not a file"
    exit 1
fi

mkdir -p ./output

${1} "${2}" ./output 2> /dev/null

for i in ./output/* ; do
    if [ -d "${i}" ]; then
        out="${i}.mp4"
        sox --rate 16k "${i}/sample.vox" "${i}.ogg" 
        ffmpeg -r 10 -y -i "${i}/%06d.png" -i "${i}.ogg" -c:v libx264 -vcodec h264 -f mp4 -pix_fmt yuv420p -vf scale=iw*2:ih*2 ${out}
        rm -rf "${i}"
    fi
done

