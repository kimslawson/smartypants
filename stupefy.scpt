on run {input, parameters}
	set currentText to input as string
	set shellEnv to "export LC_ALL=en_US.UTF-8" & "\n"
	
	set sedCommand to "sed -E \\
    -e 's/‽/\\?\\!/g' \\
    -e 's/…/\\.\\.\\./g' \\
    -e 's/—/---/g' \\
    -e 's/–/--/g' \\
    -e \"s/[‘’‘]/'/g\" \\
    -e \"s/[“”]/\\\"/g\""
	
	set fullCommand to shellEnv & "printf '%s' " & quoted form of currentText & " | " & sedCommand
	return (do shell script fullCommand)
end run
