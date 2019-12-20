Write-Output "updating powershell modules"
Update-Module

Write-Output "installing powershell modules"
$modules = @('dbatools','pswindowsupdate','carbon','dsutils','psnotes')
try {
	$modules | % {
		if (!(Get-Module $_ -ListAvailable)) {
			Write-Output "installing module: $_"
			Install-Module $_ -AllowClobber
		}
	}
}
catch {
	Write-Output $Error[0].Exception.Message 
}
