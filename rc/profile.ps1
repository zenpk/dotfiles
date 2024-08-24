$env:Path += ";$HOME\AppData\Local\Programs\oh-my-posh\bin"
$env:Path += ";C:\Program Files\Git\usr\bin"
oh-my-posh init pwsh | Invoke-Expression
oh-my-posh init pwsh --config ~/omp.json | Invoke-Expression

Import-Module -Name PSReadLine
Import-Module -Name PSFzf

Invoke-Expression (& { (zoxide init powershell | Out-String) })

function lazygit {
    param(
        [string]$msg
    )
    git add --all
    git commit -m $msg
    git push
}

function gitclonessh {
    param(
        [string]$url,
        [string]$key
    )
    git clone $url --config core.sshCommand="ssh -i ~/.ssh/$key"
}

function gitsignssh {
    param(
        [string]$key
    )
    git config gpg.format ssh
    git config user.signingkey "~/.ssh/$key"
    git config commit.gpgsign true
}

function proxyon {
    $proxyAddress = "http://127.0.0.1:1080"
    $env:http_proxy = $proxyAddress
    $env:https_proxy = $proxyAddress
}

function proxyoff {
    Remove-Item env:http_proxy
    Remove-Item env:https_proxy
}

Set-Alias -Name ll -Value ls
Set-Alias -Name l -Value ls

Set-PSReadlineOption -EditMode vi
Set-PSReadLineKeyHandler -Key Ctrl+a -Function BeginningOfLine
Set-PSReadLineKeyHandler -Key Ctrl+e -Function EndOfLine
Set-PSReadLineKeyHandler -Key Alt+f -Function ForwardWord
Set-PSReadLineKeyHandler -Key Alt+b -Function BackwardWord

Set-PSReadLineKeyHandler -Chord '"',"'" `
                         -BriefDescription SmartInsertQuote `
                         -LongDescription "Insert paired quotes if not already on a quote" `
                         -ScriptBlock {
    param($key, $arg)

    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

    if ($line.Length -gt $cursor -and $line[$cursor] -eq $key.KeyChar) {
        # Just move the cursor
        [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor + 1)
    }
    else {
        # Insert matching quotes, move cursor to be in between the quotes
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert("$($key.KeyChar)" * 2)
        [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
        [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor - 1)
    }
}

Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
