# PowerShell script to switch display resolutions between 2K and 1080p

# Define the desired resolutions
$resolutions = @(
    @{Width=2560; Height=1440},  # 2K Resolution
    @{Width=1920; Height=1080}   # 1080p Resolution
)

function Set-DisplayResolution {
    param(
        [int]$width,
        [int]$height
    )
    
    $DisplayConfig = Get-WmiObject -Namespace root\wmi -Class WmiMonitorBasicDisplayParams
    $currentWidth = $DisplayConfig.ActiveHorizontalResolution
    $currentHeight = $DisplayConfig.ActiveVerticalResolution

    # Check if the current resolution is already set to the desired resolution
    if ($currentWidth -eq $width -and $currentHeight -eq $height) {
        Write-Host "Resolution is already set to ${width}x${height}. No changes made."
    } else {
        # Change the display resolution using CIM cmdlets
        $display = Get-CimInstance -Namespace root\wmi -ClassName WmiMonitorBasicDisplayParams
        $method = $display.CimClass.CimClassMethods["WmiSetBrightness"]
        $result = $display | Invoke-CimMethod -MethodName SetDisplayConfig -Arguments @{Width = $width; Height = $height}
        
        if ($result.ReturnValue -eq 0) {
            Write-Host "Display resolution changed to ${width}x${height}"
        } else {
            Write-Host "Failed to change resolution. Error code" $result.ReturnValue
        }
    }
}

# Toggle resolution based on the current settings
$currentWidth = (Get-WmiObject -Namespace root\wmi -Class WmiMonitorBasicDisplayParams).ActiveHorizontalResolution

if ($currentWidth -eq 2560) {
    # Current resolution is 2K, switch to 1080p
    Set-DisplayResolution -width 1920 -height 1080
} else {
    # Assume the current resolution is 1080p, switch to 2K
    Set-DisplayResolution -width 2560 -height 1440
}
