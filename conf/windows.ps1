# key repeat
# https://superuser.com/questions/1058474/increase-keyboard-repeat-rate-beyond-control-panel-limits-in-windows-10
Set-Location "HKCU:\Control Panel\Accessibility\Keyboard Response"

Set-ItemProperty -Path . -Name AutoRepeatDelay       -Value 225
Set-ItemProperty -Path . -Name AutoRepeatRate        -Value 45
Set-ItemProperty -Path . -Name DelayBeforeAcceptance -Value 0
Set-ItemProperty -Path . -Name BounceTime            -Value 0
Set-ItemProperty -Path . -Name Flags                 -Value 99 
