#requires -module HaveIBeenPwned
#requires -module MSOnline

Connect-MsolService -Credential (Get-Credential)

$pcount = 0
$users = Get-MsolUser
$users | Foreach-Object {
	if ((Get-PwnedAccount -EmailAddress $_.UserPrincipalName).Count -gt 0) {
		Write-Warning "PWNED: $($_.UserPrincipalName) !!"
		$pcount++
	}
}
if ($pcount -gt 0) {
	Write-Host "uh oh! $pcount users have been pwned!" -ForegroundColor Red
}
else {
	Write-Host "congratulations! No users have been pwned!" -ForegroundColor Green
}
