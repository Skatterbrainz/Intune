#requires -module HaveIBeenPwned,MSOnline

function Get-PwnedUsers {
    param (
        [parameter(Mandatory=$False, HelpMessage="AzureAD or Active Directory")]
        [ValidateSet('AD','AzureAD')]
        [string] $Target = 'AD'
    )
    $pcount = 0
    $tcount = 0
    try {
        switch ($Target) {
            'AD' {
                $pageSize = 2000
                $as = [adsisearcher]"(objectCategory=User)"
                [void]$as.PropertiesToLoad.Add('cn')
                [void]$as.PropertiesToLoad.Add('sAMAccountName')
                [void]$as.PropertiesToLoad.Add('mail')
                [void]$as.PropertiesToLoad.Add('distinguishedName')
                $as.PageSize = $pageSize
                $results = $as.FindAll()
                foreach ($user in $results) {
                    $tcount++
                    $email = $($user.Properties.item('mail') | Out-String).Trim()
                    if (![string]::IsNullOrEmpty($email)) {
                        if ((Get-PwnedAccount -EmailAddress $email -ErrorAction SilentlyContinue).Count -gt 0) {
                            Write-Warning "PWNED: $email !!"
                            $pcount++
                        }
                    }
                }
                break;
            }
            'AzureAD' {
                Connect-MsolService -Credential (Get-Credential)
                $users = Get-MsolUser
                $users | Foreach-Object {
                    $tcount++
	                if ((Get-PwnedAccount -EmailAddress $_.UserPrincipalName).Count -gt 0) {
		                Write-Warning "PWNED: $($_.UserPrincipalName) !!"
		                $pcount++
	                }
                }
                break;
            }
        }
        if ($pcount -gt 0) {
	        Write-Host "Uh oh! $pcount of $tcount users have been pwned!" -ForegroundColor Red
        }
        else {
	        Write-Host "Congratulations! No users have been pwned. (total scanned: $tcount)" -ForegroundColor Green
        }
    }
    catch {
        Write-Error $Error[0].Exception.Message 
    }
}
