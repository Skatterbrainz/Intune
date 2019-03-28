$CName = ($($env:COMPUTERNAME).ToUpper()).Trim()
$url = "https://raw.githubusercontent.com/Skatterbrainz/Intune/master/$CName`.pkg"
Write-Output "url = $url"
try {
	$ChocoInstall = Join-Path ([System.Environment]::GetFolderPath("CommonApplicationData")) "Chocolatey\bin\choco.exe"
	if (!(Test-Path $ChocoInstall)) {
        Write-Output "installing chocolatey..."
		Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')) -ErrorAction Stop
	}
    else {
        Write-Output "chocolatey is already installed"
    }
    Write-Output "requesting: $url"
	$res = @(Invoke-RestMethod -Method Get -Uri $url -ErrorAction SilentlyContinue)
	if (![string]::IsNullOrEmpty($res)) {
		$pkglist = @($res -split [char]10)
		if ($pkglist.Count -gt 0) {
			$pkglist | Foreach-Object {
                if (![string]::IsNullOrEmpty($_)) {
    				Write-Output "installing: $_"
	    			cup $_ -y
                }
			}
			Write-Output "$($pkglist.Count) packages have been applied"
		}
		else {
			Write-Output "no packages found in remote file"
		}
	}
	else {
		Write-Output "no package list found for $UserName"
	}
	Write-Output "completed"
}
catch {
	throw $Error[0].Exception.Message
}
