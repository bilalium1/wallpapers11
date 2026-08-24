#!/usr/bin/env bash

shopt -s nullglob

# Convert PNG → JPG
for img in *.png; do
    out="${img%.png}.jpg"
    magick "$img" "$out"
done

# Delete PNGs
rm -f -- *.png

# Resize all JPGs → *_1080.jpg
for img in *.jpg; do
    [[ "$img" == *_1080.jpg ]] && continue

    out="${img%.jpg}_1080.jpg"
    magick "$img" -resize 1920x1080^ -gravity center -extent 1920x1080 "$out"
done

# Delete JPGs without _1080 suffix
for img in *.jpg; do
    [[ "$img" == *_1080.jpg ]] || rm -f -- "$img"
done
