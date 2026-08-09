#!/usr/bin/env bash

shopt -s nullglob

for img in *.png; do
    out="${img%.png}.jpg"
    magick "$img" "$out"
done
rm -rf *.png
