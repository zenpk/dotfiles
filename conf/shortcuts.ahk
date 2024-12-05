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

; https://www.autohotkey.com/boards/viewtopic.php?t=9701
*CapsLock:: {
    Send "{Blind}{LCtrl Down}"
    ; Send a LCtrl-up to fool the IME.
    SendSuppressedKeyUp("LCtrl")
    KeyWait "CapsLock"
    Send "{Blind}{LCtrl Up}"
    return
}

SendSuppressedKeyUp(key) {
    ; AutoHotkey v1.1.26+ uses this arbitrary value to signal its own hook
    ; to suppress the event.  This exists because the technique of sending
    ; and suppressing a key is already used to prevent Alt from activating
    ; the window menu in some specific cases.
    static KEY_BLOCK_THIS := 0xFFC3D450
    DllCall("keybd_event"
        , "char", GetKeyVK(key)
        , "char", GetKeySC(key)
        , "uint", 0x2 ; KEYEVENTF_KEYUP
        , "uptr", KEY_BLOCK_THIS)
}
