#!/bin/bash

# Default settings (smart mode, 1 space)
MODE="smart"
SPACE_REPLACEMENT=" "
INPUT_FILE=""

# Manual parameter loop (Bypasses broken macOS getopt)
while [[ $# -gt 0 ]]; do
    case "$1" in
        --two-space)
            SPACE_REPLACEMENT="  "
            shift
            ;;
        -s|--stupify|--stupefy)
            MODE="stupefy"
            shift
            ;;
        -*)
            echo "Unknown option: $1" >&2
            exit 1
            ;;
        *)
            # Capture the input file name
            INPUT_FILE="$1"
            shift
            ;;
    esac
done

# Function to apply typographic fixes to a string/stream
fix_typography() {
    local spaces=$(printf '\x20\x09\xc2\xa0')

    sed -E \
        -e 's/\?\!/‽/g' \
        -e 's/\!\?/‽/g' \
        -e 's/\.\.\./…/g' \
        -e 's/---/—/g' \
        -e 's/--/–/g' \
        -e "s/(^|[${spaces}(—-])'(twas|tis|cause|em|en|round|til|bout)([a-zA-Z]*)/\1’\2\3/gi" \
        -e "s/([a-zA-Z0-9])'([a-zA-Z])/\1’\2/g" \
        -e "s/'([0-9]{2})/’\1/g" \
        -e "s/(^|[([{\\\"${spaces}—-])'([a-zA-Z0-9])/\\1‘\\2/g" \
        -e "s/([a-zA-Z0-9.,?!;:‽…])'([]}\\\"${spaces}—.,;:?!)]|$)/\\1’\\2/g" \
        -e "s/(^|[([{${spaces}—-])\"([a-zA-Z0-9‘])/\\1“\\2/g" \
        -e "s/([a-zA-Z0-9.,?!;:’‽…])\"([]}\\\"${spaces}—.,;:?!)]|$)/\\1”\\2/g" \
        -e "s/[${spaces}]+([.,?!;—…‽])/\1/g" \
        -e "s/[${spaces}]+([’”])([^a-zA-Z0-9]|$)/\1\2/g" \
        -e 's/ !/!/g' -e 's/ \?/?/g' -e 's/ ‽/‽/g' \
        -e "s/[${spaces}]+([]})])/\1/g" \
        -e "s/([.?!‽][]'\"’”)]*)[${spaces}]+([^])}‘“'\"[:cntrl:]])/\1${SPACE_REPLACEMENT}\2/g" \
        -e "s/([.?!‽])[${spaces}]+([]})])/\1\\2/g"
}

# Function to reverse the typographic fixes, stupefying smart glyphs
# (and non-breaking spaces) back into their dumb ASCII equivalents
stupefy_typography() {
    local nbsp=$(printf '\xc2\xa0')

    sed -E \
        -e 's/‽/?!/g' \
        -e 's/…/.../g' \
        -e 's/—/---/g' \
        -e 's/–/--/g' \
        -e "s/‘/'/g" \
        -e "s/’/'/g" \
        -e 's/“/"/g' \
        -e 's/”/"/g' \
        -e "s/${nbsp}/ /g"
}

# Select the processing direction
if [ "$MODE" = "stupefy" ]; then
    PROCESS=stupefy_typography
else
    PROCESS=fix_typography
fi

# Process file or stdin
if [ -n "$INPUT_FILE" ] && [ -f "$INPUT_FILE" ]; then
    "$PROCESS" < "$INPUT_FILE"
else
    "$PROCESS"
fi
