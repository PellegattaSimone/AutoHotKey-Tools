~^c UP::	; first ctrl+c
keywait, space, d, t0.8		; second ctrl+space
Sleep, 100

If ErrorLevel = 0	; if second ctrl+space detected
	If TextSelected
		Run https://dictionary.cambridge.org/us/dictionary/english/%Clipboard%
	Else
		Run https://dictionary.cambridge.org/us/dictionary/english/
Return

OnClipboardChange:
TextSelected := True
Sleep, 800	; save as ctrl+c delay
TextSelected := False
Return