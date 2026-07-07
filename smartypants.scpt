on run {input, parameters}
	-- CONFIGURATION: Set to true for two spaces after sentences, false for one space.
	set useTwoSpaces to true
	
	-- Capture the incoming highlighted text
	set currentText to input as string
	
	-- Map spacing configuration to the bash flag variable
	set spaceReplacement to " "
	if useTwoSpaces then set spaceReplacement to "  "
	
	-- Build the exact unified macOS sed pipeline
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
    -e \"s/([.?!‽])[${spaces}]+([^])}‘“'\\\"[:cntrl:]])/\\1${space_rep}\\2/g\" \\
    -e \"s/([.?!‽])[${spaces}]+([]})])/\\1\\2/g\""
	
	-- Stream the text safely into the command via printf and capture the result
	set cleanedText to do shell script "printf '%s' " & quoted form of currentText & " | " & shellCommand
	
	-- Return the transformed text directly back to Shortcuts to replace it in place
	return cleanedText
end run
