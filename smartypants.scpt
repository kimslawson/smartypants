use AppleScript version "2.4" -- Yosemite (2014) or later
use scripting additions

-- ⚙️ CONFIGURATION: Set to true for two spaces after sentences, false for one space.
property useTwoSpaces : true

on run
    -- Direct test input block matching your verbatim input.txt
    set testInput to "This is a -- test -- of the emergency broadcast system ?! There should be two periods after this (if you're a heathen!! )"
    
    -- Process the text
    set outputText to fixTypography(testInput, useTwoSpaces)
    
    -- Display the final result
    display dialog outputText buttons {"OK"} default button "OK" title "SmartyPants Result"
end run

on fixTypography(inputText, doubleSpacing)
    -- Map the AppleScript boolean config to the internal bash flag variable
    set spaceReplacement to " "
    if doubleSpacing then set spaceReplacement to "  "
    
    -- Build the exact tamed macOS sed processing stack
    set shellCommand to "spaces=$(printf '\\x20\\x09\\xc2\\xa0')
space_rep=" & quoted form of spaceReplacement & "

sed -E \\
    -e 's/\\?\\!/‽/g' \\
    -e 's/\\!\\?/‽/g' \\
    -e 's/\\.\\.\\./…/g' \\
    -e 's/---/—/g' \\
    -e 's/--/–/g' \\
    -e \"s/(^|[${spaces}(—-])'(twas|tis|cause|em|en|round|til|bout)([a-zA-Z]*)/\\1’\\2\\3/gi\" \\
    -e \"s/([a-zA-Z0-9])'([a-zA-Z])/\\1’\\2/g\" \\
    -e \"s/'([0-9]{2})/\\1’\\1/g\" \\
    -e \"s/(^|[([{\\\"${spaces}—-])'([a-zA-Z0-9])/\\1‘\\2/g\" \\
    -e \"s/([a-zA-Z0-9.,?!;:])'([]}\\\"${spaces}—)]|$)/\\1’\\2/g\" \\
    -e \"s/(^|[([{${spaces}—-])\\\"([a-zA-Z0-9‘])/\\1“\\2/g\" \\
    -e \"s/([a-zA-Z0-9.,?!;:’])\\\"([]}\\\"${spaces}—)]|$)/\\1”\\2/g\" \\
    -e \"s/[${spaces}]+([.,?!;’”—…‽])/\\1/g\" \\
    -e 's/ !/!/g' -e 's/ \\?/?/g' -e 's/ ‽/‽/g' \\
    -e \"s/[${spaces}]+([]})])/\\1/g\" \\
    -e \"s/([.?!‽])[${spaces}]+([^])}‘_“'\\\"[:cntrl:]])/\\1${space_rep}\\2/g\" \\
    -e \"s/([.?!‽])[${spaces}]+([]})])/\\1\\2/g\""

    -- Safely stream multi-line string contents to the shell environment via printf
    return do shell script "printf '%s' " & quoted form of inputText & " | " & shellCommand
end fixTypography
