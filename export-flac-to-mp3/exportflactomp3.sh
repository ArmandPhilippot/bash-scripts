#!/bin/bash

for FILE in *.flac;
do
        mkdir mp3
        ffmpeg -i "$FILE" -ab 320k -map_metadata 0 "mp3/${FILE%.*}.mp3";
done
