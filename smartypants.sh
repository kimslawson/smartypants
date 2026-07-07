#!/bin/bash

# Default setting (1 space)
SPACE_REPLACEMENT=" "

# Parse command line arguments for the heathen flag
PARSED_OPTIONS=$(getopt -o "" --long two-space -- "$@")
if [ $? -eq 0 ]; then
    eval set -- "$PARSED_OPTIONS"
    while true; do
        case "$1" in
            --two-space)
                SPACE_REPLACEMENT="  "
                shift
                ;;
            --)
                shift
                break
                ;;
            *)
                echo "Programming error"
                exit 3
                ;;
        esac
    done
fi

# Function to apply typographic fixes to a string/stream
fix_typography() {
    # Store a literal tab character safely for sed matching
    local tab=$(printf '\t')

    sed -E \
        -e 's/\?\!/‽/g' \
        -e 's/\!\?/‽/g' \
        -e 's/\.\.\./…/g' \
        -e 's/---/—/g' \
        -e 's/--/–/g' \
        -e "s/(^|[ $tab([—-])'(twas|tis|cause|em|en|round|til|bout)([a-zA-Z]*)/\1’\2\3/gi" \
        -e "s/([a-zA-Z0-9])'([a-zA-Z])/\1’\2/g" \
        -e "s/'([0-9]{2})/’\1/g" \
        -e "s/(^|[([{\"$tab —-])'([a-zA-Z0-9])/\1‘\2/g" \
        -e "s/([a-zA-Z0-9.,?!;:])'([)\]}\"$tab —]|$)/\1’\2/g" \
        -e "s/(^|[([{$tab —-])\"([a-zA-Z0-9‘])/\1“\2/g" \
        -e "s/([a-zA-Z0-9.,?!;:’])\"([)\]}\"$tab —]|$)/\1”\2/g" \
        -e 's/ +([.,?!;’Material”—…‽])/ \1/g' \
        -e 's/ !/!/g' -e 's/ \?/?/g' \
        -e "s/([.?!‽]) +/\1${SPACE_REPLACEMENT}/g"
}

# Process file or stdin
if [ -n "$1" ] && [ -f "$1" ]; then
    fix_typography < "$1"
else
    fix_typography
fi
