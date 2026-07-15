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

# Aphaeresis word list: clipped forms that open with an elided-letter apostrophe
# (e.g. 'twas, 'tis, 'cause, 'em, 'round, young 'uns). Each letter is written as a
# two-case character class ([Tt][Ww]...) so matching is case-insensitive in every
# position — lower/UPPER/Title/MiXeD — WITHOUT relying on sed's non-portable "i"
# flag. Keep entries as complete words; the rule below anchors on a word boundary
# and allows an optional plural "s", so short forms like 'un no longer swallow the
# opening quote of ordinary words ('under, 'only, 'super, 'forest, 'old).
APHAERESIS='[Bb][Oo][Uu][Tt]|[Bb][Uu][Rr][Bb][Ss]|[Cc][Aa][Uu][Ss][Ee]|[Cc][Ee][Pp][Tt]|[Ee][Mm]|[Ee][Nn]|[Ff][Oo][Rr][Ee]|[Ff][Rr][Aa][Ii][Dd]|[Gg][Aa][Tt][Oo][Rr]|[Hh][Oo][Oo][Dd]|[Mm][Ii][Dd]|[Mm][Ii][Dd][Ss][Tt]|[Mm][Oo][Nn][Gg][Ss][Tt]|[Mm][Ee][Rr][Ii][Cc][Aa]|[Mm][Uu][Rr][Ii][Cc][Aa]|[Nn][Ee][Aa][Tt][Hh]|[Oo][Ll]|[Oo][Ll][Ee]|[Pp][Oo][Ss][Ss][Uu][Mm]|[Rr][Oo][Uu][Nn][Dd]|[Ss][Uu][Pp]|[Tt][Ii][Ll]|[Tt][Ii][Ss]|[Tt][Ww][Aa][Ss]|[Tt][Ww][Ee][Rr][Ee]|[Tt][Ww][Ii][Ll][Ll]|[Tt][Ww][Oo][Uu][Ll][Dd]|[Uu][Nn]'

# Function to apply typographic fixes to a string/stream
fix_typography() {
    local spaces=$(printf '\x20\x09\xc2\xa0')

    sed -E \
        -e 's/\?\!/‽/g' \
        -e 's/\!\?/‽/g' \
        -e 's/\.\.\./…/g' \
        -e 's/---/—/g' \
        -e 's/--/–/g' \
        -e ':aphaeresis' \
        -e "s/(^|[${spaces}(—-])'(${APHAERESIS})(s?)([^a-zA-Z]|$)/\1’\2\3\4/g" \
        -e 't aphaeresis' \
        -e ':contractions' \
        -e "s/([a-zA-Z0-9])'([a-zA-Z])/\1’\2/g" \
        -e 't contractions' \
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
