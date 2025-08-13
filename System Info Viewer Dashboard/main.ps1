function Draw-Box {
    param (
        [string[]] $content,
        [int] $width = 60
    )

    $top = "+" + ("-" * ($width - 2)) + "+"
    $bottom = "+" + ("-" * ($width - 2)) + "+"
    Write-Host $top

    foreach ($line in $content) {
        $paddedLine = $line.PadRight($width - 2)
        Write-Host "|$paddedLine|"
    }

    Write-Host $bottom
}

# Gather system info
$info = Get-ComputerInfo
$mem = (Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory
$procCount = [Environment]::ProcessorCount
$disks = Get-CimInstance Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 }
$lastBoot = (Get-CimInstance Win32_OperatingSystem).LastBootUpTime

# Prepare content lines
$lines = @(
    "=== System Info Dashboard ===".PadLeft(30)
    "OS Name: $($info.OSName)"
    "OS Version: $($info.OSVersion)"
    "OS Build: $($info.OSBuildNumber)"
    "Computer Name: $($info.CsName)"
    "Manufacturer: $($info.CsManufacturer)"
    "Model: $($info.CsModel)"
    "Processor: $($info.CsProcessors[0].Name)"
    "Number of Processors: $procCount"
    ("Total Physical Memory (GB): {0:N2}" -f ($mem / 1GB))
    ""
    "Disk Drives:"
)

foreach ($disk in $disks) {
    $freeGB = "{0:N2}" -f ($disk.FreeSpace / 1GB)
    $sizeGB = "{0:N2}" -f ($disk.Size / 1GB)
    $lines += "Drive $($disk.DeviceID): $freeGB GB free of $sizeGB GB"
}

$lines += ""
$lines += "Last Boot Time:"
$lines += $lastBoot.ToString()
$lines += ""
$lines += "============================="

Draw-Box -content $lines -width 60
Read-Host -Prompt "Press Enter to exit"
