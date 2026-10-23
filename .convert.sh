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

# Regenerate README.md with a showcase of every wallpaper
generate_readme() {
    shopt -s nullglob

    local files=(*.jpg *.gif)
    ((${#files[@]})) || return

    mapfile -t files < <(printf '%s\n' "${files[@]}" | sort)

    {
        printf '# Wallpapers\n\n'
        printf 'A showcase of %d wallpapers in this repository.\n\n' "${#files[@]}"
        printf '## Showcase\n\n'
        printf '| Wallpaper | Wallpaper | Wallpaper |\n'
        printf '| :---: | :---: | :---: |\n'

        local i=0
        for f in "${files[@]}"; do
            printf '| [![%s](%s)](%s) ' "$f" "$f" "$f"
            i=$((i + 1))
            ((i % 3 == 0)) && printf '|\n'
        done

        if ((i % 3 != 0)); then
            for ((j = i % 3; j < 3; j++)); do
                printf '| '
            done
            printf '|\n'
        fi
    } > README.md
}

generate_readme
