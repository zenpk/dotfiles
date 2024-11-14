#SingleInstance Force
SetCapsLockState "AlwaysOff"
SetNumLockState "AlwaysOn"

Home::RButton
PgUp::WheelUp
PgDn::WheelDown

End::^c
Insert::^v
; when using Japanese IME, using Caps+Any will cause the Ctrl to be in the held state
; press the normal Ctrl once can solve this
; a better solution would be getting a sane keyboard
CapsLock::LCtrl
NumLock::#Space
#Left::#^Left
#Right::#^Right
^[::Esc
