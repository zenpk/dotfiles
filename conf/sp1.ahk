#Requires AutoHotkey v2.0
#SingleInstance Force

SetTitleMatchMode("RegEx")
CoordMode("Mouse", "Screen")

; Constants
global kShift := 0x4
global kNone := 0x0

; Global variables for panning
global lastX := 0, lastY := 0, startX := 0, startY := 0, dragWnd := 0

; Helper function to handle reading registry values with defaults
RegReadDef(KeyName, ValueName, DefaultValue) {
    try return RegRead(KeyName, ValueName)
    catch
        return DefaultValue
}

; Setups / Default Values
global sensX := RegReadDef("HKEY_CURRENT_USER\Software\Studio Plus One", "sensX", 4)
global sensY := RegReadDef("HKEY_CURRENT_USER\Software\Studio Plus One", "sensY", 4)

; Setup Tray Menu
A_TrayMenu.Delete()
A_TrayMenu.Add("Settings", ShowSettings)
A_TrayMenu.AddStandard()

; -----------------------------------------------------------------------------
; Functions
; -----------------------------------------------------------------------------

ShowSettings(*) {
    SettingsGui := Gui("-Resize", "Settings")
    
    SettingsGui.Add("Text",, "Sensitivity X:")
    SettingsGui.Add("Edit", "vSensX w50")
    SettingsGui.Add("UpDown", "Range1-50", sensX)
    
    SettingsGui.Add("Text",, "Sensitivity Y:")
    SettingsGui.Add("Edit", "vSensY w50")
    SettingsGui.Add("UpDown", "Range1-50", sensY)
    
    BtnOK := SettingsGui.Add("Button", "Default w80", "OK")
    BtnOK.OnEvent("Click", SaveSettings)
    
    SettingsGui.Show("W400")

    SaveSettings(*) {
        ; Submit GUI and extract values
        Saved := SettingsGui.Submit()
        
        global sensX := Saved.SensX
        global sensY := Saved.SensY

        SettingsGui.Destroy()

        ; Save to registry
        RegWrite(sensX, "REG_DWORD", "HKEY_CURRENT_USER\Software\Studio Plus One", "sensX")
        RegWrite(sensY, "REG_DWORD", "HKEY_CURRENT_USER\Software\Studio Plus One", "sensY")
    }
}

CheckWin() {
    try {
        MouseGetPos(,, &wnd)
        exe := StrLower(WinGetProcessName("ahk_id " wnd))
        if (exe = "studio one.exe" || exe = "studio pro.exe") {
            return true
        }
    }
    return false
}

PostMW(hWnd, delta, modifiers, x, y) {
    CoordMode("Mouse", "Screen")
    lowOrderX := x & 0xFFFF
    highOrderY := y & 0xFFFF
    ; Note: The v1 code passed 'A' as the WinTitle which overrides the hWnd parameter. 
    ; It has been changed to 'ahk_id hWnd' so the targeted window actually receives the message.
    PostMessage(0x20A, (delta << 16) | modifiers, (highOrderY << 16) | lowOrderX,, "ahk_id " hWnd)
}

PanTimer() {
    global lastX, lastY, startX, startY, dragWnd, sensX, sensY
    MouseGetPos(&curX, &curY)
    dX := curX - lastX
    dY := curY - lastY
    scrollX := dX * sensX
    scrollY := dY * sensY
    
    if (dX != 0) {
        PostMW(dragWnd, scrollX, kShift, startX, startY)
    }
    
    if (dY != 0) {
        PostMW(dragWnd, scrollY, kNone, startX, startY)
    }

    lastX := curX
    lastY := curY
}

; -----------------------------------------------------------------------------
; Contextual Hotkeys
; -----------------------------------------------------------------------------

#HotIf CheckWin()
NumpadMult:: {
    global lastX, lastY, startX, startY, dragWnd
    MouseGetPos(&lastX, &lastY)
    MouseGetPos(&startX, &startY, &dragWnd)
    SetTimer(PanTimer, 10)
}

NumpadMult Up:: {
    SetTimer(PanTimer, 0)
}

$PgUp::Send("{Blind}{PgUp}")
$PgDn::Send("{Blind}{PgDn}")
#HotIf

