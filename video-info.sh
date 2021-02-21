#!/usr/bin/env bash

HOURNOW=$(date +%H%M%S)

echo "Extracting info from $1"

ffprobe -v error \
    -show_format \
    -of json=compact=1 \
    -pretty \
    $1 > ffprobe-$HOURNOW.out

jq  '.format.filename, .format.format_long_name, .format.duration, .format.bit_rate | select( . != null )' ./ffprobe-$HOURNOW.out > ./info-$1-$HOURNOW.out


ffprobe -v error \
    -select_streams v \
    -show_entries stream=codec_type,codec_name,codec_long_name \
    -of json=compact=1 \
    -pretty \
    $1 > ./ffprobe-$HOURNOW.out

jq  '.streams[].codec_type, .streams[].codec_name, .streams[].codec_long_name | select( . != null )' ./ffprobe-$HOURNOW.out >> ./info-$1-$HOURNOW.out


ffprobe -v error \
    -select_streams a \
    -show_entries stream=codec_type,codec_name,codec_long_name \
    -of json=compact=1 \
    -pretty \
    $1 > ./ffprobe-$HOURNOW.out

jq  '.streams[].codec_type, .streams[].codec_name, .streams[].codec_long_name | select( . != null )' ./ffprobe-$HOURNOW.out >> ./info-$1-$HOURNOW.out

echo
paste -s -d ";" ./info-$1-$HOURNOW.out
echo

rm -f ./info-$1-$HOURNOW.out ./ffprobe-$HOURNOW.out

 