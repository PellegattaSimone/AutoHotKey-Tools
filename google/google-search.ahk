~^c UP::	; first ctrl+c
keywait, x, d, t0.8		; second ctrl+x
Sleep, 100

If ErrorLevel = 0	; if second ctrl+x detected
	If TextSelected
		Run https://www.google.com/search?q=%Clipboard%
	Else
		Run https://www.google.com
Return

OnClipboardChange:
TextSelected := True
Sleep, 800	; save as ctrl+c delay
TextSelected := False
Return