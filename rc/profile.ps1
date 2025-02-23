$env:Path += ";C:\Program Files\Git\usr\bin"

function pn {
    $proxyAddress = "http://127.0.0.1:1080"
    $env:http_proxy = $proxyAddress
    $env:https_proxy = $proxyAddress
}

function pf {
    Remove-Item env:http_proxy
    Remove-Item env:https_proxy
}

Set-Alias -Name ll -Value ls
Set-Alias -Name l -Value ls

# oh-my-posh stuff
# $env:Path += ";$HOME\AppData\Local\Programs\oh-my-posh\bin"
# oh-my-posh init pwsh | Invoke-Expression
# oh-my-posh init pwsh --config ~/omp.json | Invoke-Expression
# Import-Module -Name PSReadLine
# Import-Module -Name PSFzf
# Set-PSReadLineKeyHandler -Key Ctrl+a -Function BeginningOfLine
# Set-PSReadLineKeyHandler -Key Ctrl+e -Function EndOfLine
# Set-PSReadLineKeyHandler -Key Ctrl+u -Function DeleteLine
# Set-PSReadLineKeyHandler -Key Alt+f -Function ForwardWord
# Set-PSReadLineKeyHandler -Key Alt+b -Function BackwardWord

# Set-PsFzfOption -PSReadlineChordProvider "Ctrl+t" -PSReadlineChordReverseHistory "Ctrl+r" -PSReadlineChordSetLocation "Ctrl+q"

# change resolution to 2k, install https://www.powershellgallery.com/packages/DisplaySettings first
function res2k {
    Set-DisplayResolution -Width 2560 -Height 1440
}

function res1080 {
    Set-DisplayResolution -Width 1920 -Height 1080
}
