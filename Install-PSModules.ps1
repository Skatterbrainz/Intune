Write-Output "installing powershell modules"
$modules = @('pswindowsupdate','carbon')
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