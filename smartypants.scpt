on run {input, parameters}
	set currentText to input as string
	
	-- Python script to handle complex regex smart-quotes logic
	set pythonScript to "import sys, re
text = sys.stdin.read()

# Easter Egg: Interrobang
text = re.sub(r'\?\!', '‽', text)
text = re.sub(r'\!\?', '‽', text)

# Ellipses and Dashes
text = re.sub(r'\\.\\.\\.', '…', text)
text = re.sub(r'---', '—', text)
text = re.sub(r'--', '–', text)

# Handle leading word omissions ('twas, 'tis, 'em, etc.)
text = re.sub(r'(^|[\\s([-—])\'(twas|tis|cause|em|en|round|til|bout)(\\b|[a-zA-Z]*)', r'\\1’\\2\\3', text, flags=re.IGNORECASE)

# Contractions (isn't) and leading years ('98)
text = re.sub(r'([a-zA-Z0-9])\'([a-zA-Z])', r'\\1’\\2', text)
text = re.sub(r'\'([0-9]{2})', r'’\\1', text)

# Opening and Closing Single Quotes
text = re.sub(r'(^|[-—([{\\s])\'([a-zA-Z0-9])', r'\\1‘\\2', text)
text = re.sub(r'([a-zA-Z0-9.,?!;:])\'([)\\]}\\s]|$)', r'\\1’\\2', text)

# Opening and Closing Double Quotes
text = re.sub(r'(^|[-—([{\\s])\"([a-zA-Z0-9‘])', r'\\1“\\2', text)
text = re.sub(r'([a-zA-Z0-9.,?!;:’])\"([)\\]}\\s]|$)', r'\\1”\\2', text)

# QOL: Clean up accidental spaces before punctuation
text = re.sub(r'\\s+([.,?!;…‽])', r'\\1', text)

# Space-after-period normalization (Change to r'\\1  ' below if you desire heathen status here)
text = re.sub(r'([.?!‽])\\s+', r'\\1 ', text)

print(text, end=\"\")"

	-- Run the python script passing the selected text via stdin
	set cleanedText to do shell script "echo " & quoted form of currentText & " | python3 -c " & quoted form of pythonScript
	
	return cleanedText
end run