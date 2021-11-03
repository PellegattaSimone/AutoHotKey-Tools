#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetStoreCapsLockMode, Off
; install mouse hook - it is needed to read the physical state 
; of the mouse button if it is blocked by another thread
#InstallMouseHook

; === SETTINGS ===
k := 0.1														; scroll speed coefficient (higher k = more speed)
T := 300														; double-Rightclick threshold, millseconds
swap := true 													; swap scroll direction
; swap := false 
movelimit := 15													; max amount of scroll at once (better leave as is)
; ================

; min function
min(a, b) {
	if (b < a) {
		return b
	}
	return a
}

; scroll function : d = direction, n = amount of scrolls
scroll(d, n) {
	if (d = 1) {
		send, { wheeldown %n% } 
	}
	if (d = 0) {
		send, { wheelup %n% } 
	}
}

mousegetpos, , Yp												; get mouse Y position
panp := getkeystate("rbutton", "P")								; save key state / set the key used to scroll
tikp := A_TickCount												; save time
dY := 0
totalMoves := 0

loop
{
	GetKeyState, active, Alt										; disable if control is pressed

	if(active != "D")
	{
		sleep 10
		pan := getkeystate("rbutton", "P")							; set the key used to scroll
		pan_on := (pan > panp)										; check if key state is changed 
		pan_off := (pan < panp)										; check if key state is changed 
		panp := pan

		; tooltip %pan%
		mousegetpos, , Y											; get current mouse position Y
		dY := dY + (k * (Y - Yp))									; relative mouse movement
		Yp := Y														; save Y position
		moves := min(floor(abs(dY)), movelimit)						; amount of scroll events per once
		direct := (dY >= 0) ^ swap									; get direction

		if (moves = movelimit) {
			dY := 0													; dY should always go to zero if movelimit is reached
		} else {
			dY := dY - (moves * (-1)**(dY < 0))						; dY remainder should remain for next loop (incase mouse is moving slowly)
		}

		; tooltip,  %direct% , %dY%	
		if (pan = true) {
			if !(WinActive("ahk_class GLFW30") || WinActive("ahk_exe Unity.exe"))			; if not specific windows
			{
				scroll(direct, moves)								; SCROLL <----------

				totalMoves := totalMoves + moves
			}
		}
		if (pan_off = true) {
			if (totalMoves = 0) {
				send {rbutton}										; right click if no movement
			}
			totalMoves := 0
		}	 
	}
}

; exitapp
