# SmartyPants

A pair of lightweight, idempotent scripts (Bash & macOS AppleScript/Shortcuts) designed to automatically upgrade standard text into beautiful, typographically correct prose. 

It handles curly quotes, proper dashes, ellipses, word-omission contractions, handles spacing standardization, and includes a fun little interrobang easter egg.

## Features

* **Smart Quotes:** Converts straight quotes (`'`) and (`"`) to their curly counterparts (`‘`, `’`, `“`, `”`).
* **Contraction Awareness:** Properly preserves leading apostrophes for historical contractions like `'twas`, `'tis`, `'cause`, `'em`, and truncated years like `'98`.
* **Dashes & Ellipses:** Converts `--` to an en-dash (`–`), `---` to an em-dash (`—`), and `...` to an ellipsis (`…`).
* **Whitespacing QOL:** Automatically trims accidental spaces trailing right before punctuation marks.
* **Sentence Spacing Normalization:** Cleans up irregular spacing after sentences, supporting both modern single-space standards and classic double-space typography.
* **Idempotent:** Safe to run repeatedly on the same block of text without risking recursion or broken formatting.
* **Easter Egg:** Converts `!?` or `?!` into a glorious interrobang (`‽`).

---

## Installation & Usage

### 1. Bash Script (`smartypants.sh`)
Perfect for command-line efficiency, treating text processing like a fast conveyor belt.

**Civilized Mode (Default):**
By default, the script normalizes all sentence endings (`.`, `?`, `!`, and `‽`) to use exactly **one space**.
```bash
echo "Stop!  Who goes there?!  Wait..." | ./smartypants.sh
# Output: Stop! Who goes there‽ Wait…```

**Heathen Mode (--two-space):**
For traditionalists or specific style guides, passing the --two-space flag forces exactly two spaces after all sentence-ending punctuation (including the interrobang).
```bash
./smartypants.sh --two-space input.txt > output.txt```

### 2. macOS Quick Action / Shortcut
Bring typographic fixes to any text field across macOS via a Services menu or keyboard shortcut.

1. Open the **Shortcuts** app on macOS and create a new **Quick Action**.
2. Set it to receive **Current Shortcut Input** (or "Selected Text") from **any application**.
3. Add a **Run AppleScript** action and paste the script provided in this repository.
4. Set the output to replace the selected text.
5. Highlight any text in macOS, right-click -> **Services** -> **SmartyPants** to instantly clean your text.

*(Note: The macOS script defaults to Civilized Mode. To unlock Heathen Mode on macOS, edit the Python snippet inside the AppleScript to replace `r'\\1 '` with `r'\\1  '` near the bottom).*

---

## Limitations

Because these scripts rely purely on regex pattern-matching substitutions (`sed` in Bash, `re` in Python/AppleScript) rather than an abstract syntax tree (AST) parser, **they do not recognize code blocks or HTML tags.** Running these scripts directly over raw Markdown files containing code or HTML files with inline attributes will "smart-quote" your code syntax and break it. Use primarily on raw prose, markdown text nodes, or drafts.

---

## Acknowledgments & Inspiration

This project owes a profound debt of gratitude to **John Gruber** and his original 2003 implementation of **SmartyPants**. 

Gruber’s OG web publishing utility paved the way for modern web typography by proving that web writers shouldn't be held hostage by the limitations of the standard QWERTY keyboard layout. This utility stands on the shoulders of that classic implementation, adapting those core smart-punctuation principles into a nimble, dual-pronged workflow for modern CLI and macOS environments.