#!/bin/zsh
# https://specifications.freedesktop.org/thumbnail-spec/thumbnail-spec-latest.html

# URL encoding / percent-encoding
function url_decode() {
    # : "${*//+/ }" # reserve + symbol, because space encoded as %20
    printf "${_//\%/\\x}"
}

count=0
request_count=$#
thumb_type=normal # large x-large xx-large

total_thumb=$(fd -e png --search-path ~/.cache/thumbnails/"${thumb_type}" | wc -l)
search_thumb=0

ProgressBar() {
    local current=$1
    local total=$2
    local file=$3
    local now=$((current * 100 / total))
    local last=$(((current - 1) * 100 / total))
    [[ $((last % 2)) -eq 1 ]] && let last++
    local str=$(for i in $(seq 1 $((last / 2))); do printf '#'; done)
    for ((i = $last; $i <= $now; i += 2)); do
        printf "\r%s\n[%-50s]%3d%%\n" "$file" "$str" "$i"
        sleep 0.02
        str+='#'
        if [[ i -ne 50 ]]; then
            printf "\e[2A"
        fi
    done
}

for file in ~/.cache/thumbnails/"${thumb_type}"/*.png; do
    search_thumb=$((search_thumb + 1))
    ProgressBar $search_thumb $total_thumb $file
    if [[ -z $file ]]; then
        continue
    fi
    origin_file=$(exiftool $file | awk -F': ' '/^Thumb URI/{print substr($2,8)}')
    origin_file_decode=$(url_decode $origin_file)
    if [[ -z $origin_file ]]; then
        continue
    fi
    for arg in $@; do
        request_file=$(realpath $arg)
        if [[ $origin_file_decode == $request_file ]]; then
            echo $origin_file_decode - $file
            count=$((counter + 1))
            rm $file
            break
        fi
    done
    if [[ $count -eq $request_count ]]; then
        break
    fi
done
