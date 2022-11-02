function InstallUpdates
{
    Install-Module PSWindowsUpdate
    Get-WindowsUpdate -AcceptAll -Install
    Write-Host "Windows Updated"
}
function SetDarkTheme
{
    Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -Value 0
    Write-Host "Windows Theme Changed"
}

function SetDateFormat
{
    $culture = Get-Culture
    $culture.DateTimeFormat.ShortDatePattern = 'dd/MM/yyyy'
    Set-Culture $culture
    Write-Host "Date Format Changed"
}

function CopyCommonlyUsedFolders
{
    $SourcePath = "D:\format\*"
    $DestinationPath = "C:\Users\Admin\Desktop"
    Copy-Item -Path $SourcePath -Destination $DestinationPath  -Recurse
    Write-Host "Often used folders copied"
}

function InstallTerminal
{
    winget install --id Microsoft.Powershell --source winget
    winget install --id Microsoft.WindowsTerminal -e
    mkdir "C:\Users\Admin\AppData\Local\terminal"
    reg import .\OpenWithTerminal.reg
    Update-Help
    Write-Host "Windows Terminal Installed"
}

function InstallMSOffice
{
    $SourcePath = "D:\Torrenty\o2021.10.2021.32+64.pl+en\Office_2021_ProPlus_Retail_Pazdziernik_2021_32-bit+64-bit_PL.img"
    $mount = Mount-DiskImage $SourcePath
    $driveLetter = ($mount | Get-Volume).DriveLetter
    $drive = $driveLetter + ':\'
    $path =  $drive + 'Setup.exe'
    Get-PSDrive > $null
    start $path 
    Dismount-DiskImage $SourcePath
    Write-Host "MS Office Installed"
}

function InstallOftenUsedPrograms
{
    $packages = @("Google.Chrome","Winamp.Winamp","XPDBZ4MPRKNN30","Discord.Discord","RARLab.WinRAR","Git.Git","XP9KHM4BK9FZ7Q","OpenJS.NodeJS","XPDCFJDKLZJLP8")
    foreach($package in $packages)
    {
        winget install --id $package --accept-source-agreements --accept-package-agreements --location "D:\Program Files\$package"
        Write-Host "$package Installed"
    }
    reg import .\OpenWithCode.reg
}

& InstallUpdates
& SetDarkTheme
& SetDateFormat
& CopyCommonlyUsedFolders
& InstallTerminal
& InstallMSOffice
& InstallOftenUsedPrograms