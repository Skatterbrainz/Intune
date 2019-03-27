$pkglist = @("7zip","adobereader","git","notepadplusplus","paint.net","vscode","vscode-powershell","vscode-icons","vlc","sysinternals","keepass")
$ChocoInstall = Join-Path ([System.Environment]::GetFolderPath("CommonApplicationData")) "Chocolatey\bin\choco.exe"
if (!(Test-Path $ChocoInstall)) {
	try {
		Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')) -ErrorAction Stop
	}
	catch {
		Throw "Failed to install Chocolatey"
	}       
}

try {
	$pkglist | Foreach-Object { 
		Write-Output "installing: $_"
		cup $_ -y 
	}
}
catch {
	Write-Output "failed to install package: $_"
}
