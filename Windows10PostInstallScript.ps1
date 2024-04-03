function InstallUpdates
{
    Write-Host "Updating Windows..."
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
    # installing theme
    winget install JanDeDobbeleer.OhMyPosh -s winget
    oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\jandedobbeleer.omp.json" | Invoke-Expression
    oh-my-posh font install FiraCode
    # need to change font to FiraCode by replacing settings.json
    Copy-Item -Path "setting.json" -Destination "C:\Users\Admin\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\setting.json" -Force
    Add-Content -Path $PROFILE.CurrentUserAllHosts -Value "Add-Content -Path `$PROFILE.CurrentUserAllHosts -Value 'oh-my-posh init pwsh --config ''C:\Users\Admin\AppData\Local\Programs\oh-my-posh\themes\capr4n.omp.json'' | Invoke-Expression'"
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
}

& InstallUpdates
& SetDarkTheme
& SetDateFormat
& CopyCommonlyUsedFolders
& InstallTerminal
& InstallOftenUsedPrograms