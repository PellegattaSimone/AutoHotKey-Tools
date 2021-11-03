~^c UP::	; first ctrl+c
keywait, c, d, t0.8		; second ctrl+c
Sleep, 100

If ErrorLevel = 0	; if second ctrl+c detected
	If !TextSelected
		Run php -f ".\google-translate.php",,hide	; https://translate.google.com?sl=auto
	Else {
		escapedClipboard := StrReplace(Clipboard, chr(34), "\""")	; escapes double quotes inside the clipboard
		Run php -f ".\google-translate.php" text="%escapedClipboard%",,hide	; https://translate.google.com?sl=auto&tl={$response->language}&text=%Clipboard%
	}
Return

OnClipboardChange:
TextSelected := True
Sleep, 800	; save as ctrl+c delay
TextSelected := False
Return