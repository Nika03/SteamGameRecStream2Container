#!/usr/bin/env bash

dest_dir="output_$(date +%Y-%m-%d_%H-%M-%S)"

echo "$(date "+%Y-%m-%d %H:%M:%S:%N") [INFO] Creating an output directory - $dest_dir" | tee -a /tmp/convert.log
mkdir "$dest_dir"

shopt -s nullglob

for file in chunk-stream0-*.m4s; do
    digits=${file##*-}     # e.g. 00042.m4s
    digits=${digits%.m4s}  # e.g. 00042

    echo "$(date "+%Y-%m-%d %H:%M:%S:%N") [INFO] Combining video init stream with stream chunk $digits into an mp4 file" | tee -a /tmp/convert.log
    cat "init-stream0.m4s" "chunk-stream0-$digits.m4s" > "./$dest_dir/video-chunk-$digits.mp4"

    echo "$(date "+%Y-%m-%d %H:%M:%S:%N") [INFO] Logging the file for ffmpeg concatenation" | tee -a /tmp/convert.log
    echo "file 'video-chunk-$digits.mp4'" >> "./$dest_dir/video-chunks.txt"

    echo "$(date "+%Y-%m-%d %H:%M:%S:%N") [INFO] Remuxing the video chunk $digits to unfuck the container timing" | tee -a /tmp/convert.log
    ffmpeg -i "./$dest_dir/video-chunk-$digits.mp4" -c copy -fflags +genpts "./$dest_dir/video-chunk-$digits.fixed.mp4"

    echo "$(date "+%Y-%m-%d %H:%M:%S:%N") [INFO] Deleting the fucked video chunk" | tee -a /tmp/convert.log
    rm "./$dest_dir/video-chunk-$digits.mp4"

    echo "$(date "+%Y-%m-%d %H:%M:%S:%N") [INFO] Renaming the unfucked video chunk" | tee -a /tmp/convert.log
    mv "./$dest_dir/video-chunk-$digits.fixed.mp4" "./$dest_dir/video-chunk-$digits.mp4"


    echo "$(date "+%Y-%m-%d %H:%M:%S:%N") [INFO] Combining audio init stream with stream chunk $digits into an mp4 file" | tee -a /tmp/convert.log
    cat "init-stream1.m4s" "chunk-stream1-$digits.m4s" > "./$dest_dir/audio-chunk-$digits.mp4"

    echo "$(date "+%Y-%m-%d %H:%M:%S:%N") [INFO] Logging the file for ffmpeg concatenation" | tee -a /tmp/convert.log
    echo "file 'audio-chunk-$digits.mp4'" >> "./$dest_dir/audio-chunks.txt"

    echo "$(date "+%Y-%m-%d %H:%M:%S:%N") [INFO] Remuxing the audio chunk $digits to unfuck the container timing" | tee -a /tmp/convert.log
    ffmpeg -i "./$dest_dir/audio-chunk-$digits.mp4" -c copy -fflags +genpts "./$dest_dir/audio-chunk-$digits.fixed.mp4"

    echo "$(date "+%Y-%m-%d %H:%M:%S:%N") [INFO] Deleting the fucked audio chunk" | tee -a /tmp/convert.log
    rm "./$dest_dir/audio-chunk-$digits.mp4"

    echo "$(date "+%Y-%m-%d %H:%M:%S:%N") [INFO] Renaming the unfucked audio chunk" | tee -a /tmp/convert.log
    mv "./$dest_dir/audio-chunk-$digits.fixed.mp4" "./$dest_dir/audio-chunk-$digits.mp4"
done

echo "$(date "+%Y-%m-%d %H:%M:%S:%N") [INFO] Changing directory into $dest_dir" | tee -a /tmp/convert.log
cd ./$dest_dir

echo "$(date "+%Y-%m-%d %H:%M:%S:%N") [INFO] Starting the concatenation of the video chunks into a continuous stream" | tee -a /tmp/convert.log
ffmpeg -f concat -i video-chunks.txt -c copy video-whole.mp4 | tee -a /tmp/convert.log

echo "$(date "+%Y-%m-%d %H:%M:%S:%N") [INFO] Concatenation finished, deleting the video chunks and video-chunks.txt" | tee -a /tmp/convert.log
rm video-chunk-*.mp4
rm video-chunks.txt

echo "$(date "+%Y-%m-%d %H:%M:%S:%N") [INFO] Starting the concatenation of the audio chunks into a continuous stream" | tee -a /tmp/convert.log
ffmpeg -f concat -i audio-chunks.txt -c copy audio-whole.mp4 | tee -a /tmp/convert.log

echo "$(date "+%Y-%m-%d %H:%M:%S:%N") [INFO] Concatenation finished, deleting the audio chunks and audio-chunks.txt" | tee -a /tmp/convert.log
rm audio-chunk-*.mp4
rm audio-chunks.txt

echo "$(date "+%Y-%m-%d %H:%M:%S:%N") [INFO] Combining video and audio streams into one container" | tee -a /tmp/convert.log
ffmpeg -i video-whole.mp4 -i audio-whole.mp4 -c copy -tag:v hvc1 output.mp4 | tee -a /tmp/convert.log

echo "$(date "+%Y-%m-%d %H:%M:%S:%N") [INFO] Removing the separate streams" | tee -a /tmp/convert.log
rm video-whole.mp4
rm audio-whole.mp4

echo "$(date "+%Y-%m-%d %H:%M:%S:%N") [INFO] Done" | tee -a /tmp/convert.log
cp /tmp/convert.log ./convert.log
rm /tmp/convert.log
