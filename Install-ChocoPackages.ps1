$pkglist = @("7zip","git","github-desktop","notepadplusplus","paint.net","vscode","vscode-powershell","vscode-icons","microsoft-edge-insider-dev")
$ChocoInstall = "$env:ProgramData\Chocolatey\bin\choco.exe"
if (!(Test-Path $ChocoInstall)) {
	Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')) -ErrorAction Stop
}
try {
	$pkglist | Foreach-Object { 
		Write-Output "installing: $_"
		cinst $_ -y 
	}
}
catch {
	Write-Output "failed to install package: $_"
}
