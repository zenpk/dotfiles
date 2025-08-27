#SingleInstance Force
SetCapsLockState "AlwaysOff"
SetNumLockState "AlwaysOn"

Home::RButton
PgUp::WheelUp
PgDn::WheelDown

End::^c
Insert::^v
NumLock::#Space
#Left::#^Left
#Right::#^Right
^[::Esc
RControl::MButton


; https://www.autohotkey.com/boards/viewtopic.php?t=9701
; This should be replaced by whatever your native language is. See 
; https://learn.microsoft.com/en-us/windows/win32/intl/language-identifier-constants-and-strings
; for the language identifiers list.
global ja := DllCall("LoadKeyboardLayout", "Str", "00000411", "Int", 1)
global en := DllCall("LoadKeyboardLayout", "Str", "00000409", "Int", 1)

*CapsLock:: {
    global ja, en
    w := DllCall("GetForegroundWindow")
    pid := DllCall("GetWindowThreadProcessId", "UInt", w, "Ptr", 0)
    layout := DllCall("GetKeyboardLayout", "UInt", pid)
    if (layout == ja) {
        PostMessage 0x50, 0, en,, "A"
    }
    SetKeyDelay -1
    Send "{Blind}{LCtrl DownR}"
    KeyWait "CapsLock"
    Send "{Blind}{LCtrl Up}"
    if (layout != en) {
        PostMessage 0x50, 0, layout,, "A"
    }
    return
}
