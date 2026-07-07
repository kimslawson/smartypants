on run {input, parameters}
	-- CONFIGURATION: Set to true for two spaces after sentences, false for one space.
	set useTwoSpaces to false
	
	-- Capture the incoming highlighted text
	set currentText to input as string
	
	-- Map spacing configuration to the bash flag variable
	set spaceReplacement to " "
	if useTwoSpaces then set spaceReplacement to "  "
	
	-- 1. Build the environment and variables BEFORE the pipe
	set shellEnv to "export LC_ALL=en_US.UTF-8
spaces=$(printf '\\x20\\x09\\xc2\\xa0')
space_rep=" & quoted form of spaceReplacement & "
"
	
	-- 2. The sed engine command
	set sedCommand to "sed -E \\
    -e 's/\\?\\!/‽/g' \\
    -e 's/\\!\\?/‽/g' \\
    -e 's/\\.\\.\\./…/g' \\
    -e 's/---/—/g' \\
    -e 's/--/–/g' \\
    -e \"s/(^|[${spaces}(—-])'(twas|tis|cause|em|en|round|til|bout)([a-zA-Z]*)/\\1’\\2\\3/gi\" \\
    -e \"s/([a-zA-Z0-9])'([a-zA-Z])/\\1’\\2/g\" \\
    -e \"s/'([0-9]{2})/’\\1/g\" \\
    -e \"s/(^|[([{\\\"${spaces}—-])'([a-zA-Z0-9])/\\1‘\\2/g\" \\
    -e \"s/([a-zA-Z0-9.,?!;:‽…])'([]}\\\"${spaces}—.,;:?!)]|$)/\\1’\\2/g\" \\
    -e \"s/(^|[([{${spaces}—-])\\\"([a-zA-Z0-9‘])/\\1“\\2/g\" \\
    -e \"s/([a-zA-Z0-9.,?!;:’\\‽…])\\\"([]}\\\"${spaces}—.,;:?!)]|$)/\\1”\\2/g\" \\
    -e \"s/[${spaces}]+([.,?!;—…\\‽])/\\1/g\" \\
    -e \"s/[${spaces}]+([’”])([^a-zA-Z0-9]|$)/\\1\\2/g\" \\
    -e 's/ !/!/g' -e 's/ \\?/?/g' -e 's/ ‽/‽/g' \\
    -e \"s/[${spaces}]+([]})])/\\1/g\" \\
    -e \"s/([.?!\\‽][]'\\\"’”)]*)[${spaces}]+([^])}‘“'\\\"[:cntrl:]])/\\1${space_rep}\\2/g\" \\
    -e \"s/([.?!‽])[${spaces}]+([]})])/\\1\\2/g\""
	
	-- 3. Combine it all
	set fullCommand to shellEnv & "printf '%s' " & quoted form of currentText & " | " & sedCommand
	
	-- Execute and return directly to Shortcuts
	set cleanedText to do shell script fullCommand
	
	return cleanedText
end run