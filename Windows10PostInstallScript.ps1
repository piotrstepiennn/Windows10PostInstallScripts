function InstallUpdates
{
    Write-Host "Updating Windows..."
    Install-Module PSWindowsUpdate
    Get-WindowsUpdate -AcceptAll -Install
    Update-Help
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

function InstallWinget
{
    $progressPreference = 'silentlyContinue'
    Write-Information "Downloading WinGet and its dependencies..."
    Invoke-WebRequest -Uri https://aka.ms/getwinget -OutFile Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
    Invoke-WebRequest -Uri https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx -OutFile Microsoft.VCLibs.x64.14.00.Desktop.appx
    Invoke-WebRequest -Uri https://github.com/microsoft/microsoft-ui-xaml/releases/download/v2.8.6/Microsoft.UI.Xaml.2.8.x64.appx -OutFile Microsoft.UI.Xaml.2.8.x64.appx
    Add-AppxPackage Microsoft.VCLibs.x64.14.00.Desktop.appx
    Add-AppxPackage Microsoft.UI.Xaml.2.8.x64.appx
    Add-AppxPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
    Write-Host "Winget Installed"
}

function InstallTerminal
{
    Write-Host "Installing Powershell Core and Windows Terminal"
    winget install --id Microsoft.Powershell --accept-source-agreements --accept-package-agreements --source winget
    winget install --id Microsoft.WindowsTerminal --accept-source-agreements --accept-package-agreements -e
    mkdir "C:\Users\Admin\AppData\Local\terminal"
    reg import .\OpenWithTerminal.reg
    Write-Host "Windows Terminal Installed"
    # installing theme
    winget install JanDeDobbeleer.OhMyPosh --accept-source-agreements --accept-package-agreements -s winget
    Exit-PSSession
    Start-Process powershell.exe
    & ".\initOhMyPosh.ps1"
    # need to change font to FiraCode by replacing settings.json
    Copy-Item -Path "settings.json" -Destination "C:\Users\Admin\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" -Force
    Add-Content -Path $PROFILE.CurrentUserAllHosts -Value 'oh-my-posh init pwsh --config C:\Users\Admin\AppData\Local\Programs\oh-my-posh\themes\capr4n.omp.json | Invoke-Expression'
    Write-Host "Windows Terminal Theme Installed"
}

function InstallOftenUsedPrograms
{
    $packages = @("Google.Chrome","Winamp.Winamp","VideoLAN.VLC","Discord.Discord","RARLab.WinRAR","Git.Git","XP9KHM4BK9FZ7Q","OpenJS.NodeJS","Valve.Steam","Docker.DockerDesktop","Adobe.Acrobat.Reader.64-bit","Oracle.VirtualBox","Oracle.JDK.19","Python.Python.3.11")
    foreach($package in $packages)
    {
        winget install --id $package --accept-source-agreements --accept-package-agreements --location "C:\Program Files\$package"
        Write-Host "$package Installed"
    }
    reg import .\OpenWithCode.reg
    $Arguments = @(
    "/S"
    "/V/qn"
    )
    Start-Process -Wait -FilePath "..\QTTabBar.exe" -ArgumentList $Arguments -NoNewWindow -PassThru
    Start-Process -Wait -FilePath "..\Adobe.Acrobat.Pro.DC.2020.006.20042.Preattivato.Multi-[WEB]\Setup.exe" -ArgumentList $Arguments -NoNewWindow -PassThru
    Write-Host "Often used programs installed"
    Write-Host "Windows 10 Post Install Script Complete"
}

& InstallUpdates
& SetDarkTheme
& SetDateFormat
& CopyCommonlyUsedFolders
& InstallWinget
& InstallTerminal
& InstallOftenUsedPrograms