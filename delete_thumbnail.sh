#!/bin/zsh
# https://specifications.freedesktop.org/thumbnail-spec/thumbnail-spec-latest.html

thumb_types=(normal large x-large xx-large)

# URL encoding / percent-encoding
function url_encode() {
    local length="${#1}" # len of $1

    for ((i = 0; i < length; i++)); do
        local c="${1:$i:1}"
        case $c in
        [a-zA-Z0-9.~_\-//:]) printf "$c" ;;
        *) printf "$c" | xxd -u -p -c1 | while read x; do printf "%%%s" "$x"; done ;;
        esac
    done
}

for arg in "$@"; do
    request_file="file://$(realpath $arg)"
    thumb_name=$(printf "%s" $(url_encode $request_file) | md5sum)
    thumb_name=${thumb_name//[ -]/}

    for type in "${thumb_types[@]}"; do
        thumb_file="$HOME/.cache/thumbnails/${type}/${thumb_name}.png"
        if [[ ! -e $thumb_file ]]; then
            printf "no $type thumbnails\n"
        else
            rm $thumb_file
        fi
    done
done
