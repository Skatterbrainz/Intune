$apps = "7zip,adobereader,azurepowershell,git,google-backup-and-sync,GoogleChrome,jing,keepass,
microsoft-teams,microsoftazurestorageexplorer,notepadplusplus,obs-studio,paint.net,Pester,
putty,rdcman,slack,sysinternals,visualstudio2017community,vlc,vscode,vscode-azurerm-tools,
vscode-csharp,vscode-icons,vscode-mssql,vscode-powershell,wmiexplorer"

try {
    if (Test-Path "$($env:PROGRAMDATA)\chocolatey\choco.exe") {
        Write-Output "chocolatey is already installed"
    }
    else {
        Write-Output "installing chocolatey"
        Set-ExecutionPolicy Bypass -Scope Process -Force
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    }
    $apps -split ',' | Foreach-Object {
        Write-Output "installing: $_"
        cup $_ -y
    }
}
catch {
    Write-Output "Error: $($error[0].Exception.Message -join ",")"
}