# Check and run as administrator if not already
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
   $arguments = "& '" + $myinvocation.mycommand.definition + "'"
   Start-Process powershell -Verb runAs -ArgumentList $arguments
   Break
}

# Set console window size
$host.UI.RawUI.WindowSize = New-Object System.Management.Automation.Host.Size(65, 25)

# User input
$baseName = Read-Host "Input the firewall rule name"
$defaultPath = $PWD.Path
$exePath = Read-Host "Input the exe path (default $defaultPath)"
if ($exePath -eq "") {
    $exePath = $defaultPath
}
$confirmAll = $false

Get-ChildItem -Path $exePath -Filter *.exe -Recurse | ForEach-Object {
    $ruleName = "$baseName-$($_.FullName)"

    if ($confirmAll -eq $false) {
        Write-Host "About to add rule $ruleName for $($_.FullName)"
        $readKey = Read-Host "Confirm? Press a/A to confirm all"
        if ($readKey -eq 'a' -or $readKey -eq 'A') {
            $confirmAll = $true
        }
    }

    # Remove any existing rule with the same name
    netsh advfirewall firewall delete rule name="$ruleName" | Write-Host
    # Add new rule to block the .exe
    netsh advfirewall firewall add rule name="$ruleName" program="$($_.FullName)" action=block dir=out | Write-Host
    Write-Host "Rule $ruleName added"
}
Write-Host "Done, press any key to quit"
$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
