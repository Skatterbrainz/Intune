$klist = @('Alarms','FeedbackHub','BingWeather','GetStarted','Solitaire','SoundRecorder','YourPhone',
'Wallet','OneConnect','StickyNotes','OfficeHub','3DViewer','Messaging','MixedReality.Portal',
'Office.OneNote','People','Print3D','Camera','Maps','Photos','ScreenSketch','SkypeApp','Xbox','Zune')
$appxlist = Get-AppxProvisionedPackage -Online | Select-Object DisplayName,PackageName | Sort-Object DisplayName
Write-Output "cleaning system packages"
foreach ($app in $appxlist) {
	foreach ($kill in $klist) {
		if ($app.DisplayName -match $kill) {
			try {
				if ($WhatIfPreference) {
					Write-Information "WhatIf: Remove-AppxPackage -PackageName $($app.PackageName) -AllUsers -Online"
				}
				else {
					Remove-AppxProvisionedPackage -PackageName $app.PackageName -AllUsers -Online -ErrorAction SilentlyContinue | Out-Null
				}
				Write-Host "removed: $($app.DisplayName)" -ForegroundColor Magenta
			}
			catch {
				Write-Warning "failed to remove package: $($app.DisplayName) - $($Error[0].Exception.Message)"
			}
		}
	}
}
Write-Output "cleaning user packages"
$klist = @('BingNews','windowscommunicationsapps','Microsoft.Whiteboard','NetworkSpeedTest','Office.Sway','OfficeLens','RemoteDesktop','Todos')
$appxlist = Get-AppxPackage | Where-Object {$_.NonRemovable -eq $False} | Select-Object Name,PackageFullName,NonRemovable | Sort-Object Name
foreach ($app in $appxlist) {
	Write-Host $app.Name -ForegroundColor Cyan
	foreach ($kill in $klist) {
		if ($app.Name -match $kill) {
			Write-Verbose "`tremoving: $($app.Name)"
			try {
				Remove-AppxPackage -Package $app.PackageFullName -Confirm:$False
				Write-Host "removed: $($app.Name)" -ForegroundColor Magenta
			}
			catch {
				Write-Warning "failed to remove package: $($app.Name) - $($Error[0].Exception.Message)"
			}
		}
	}
}
