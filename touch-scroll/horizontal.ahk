; Scroll left with right key + wheel up

+WheelUp:: ; Scroll left
ControlGetFocus, control, A
SendMessage, 0x114, 0, 0, %control%, A ; 0x114 is WM_HSCROLL
return

; Scroll left with left key + wheel down

+WheelDown:: ; Scroll right
ControlGetFocus, control, A
SendMessage, 0x114, 1, 0, %control%, A ; 0x114 is WM_HSCROLL
return

exitapp