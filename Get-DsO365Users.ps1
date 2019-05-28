#requires -Modules msonline,azuread
param (
    [string] $CredUser = "dave@skatterbrainz.xyz",
    [string] $userUPN = 'azrun@skatterbrainz.xyz'
)

try {
    if (!$cred) {
        $cred = Get-Credential -Message "O365 Credentials" -UserName $CredUser
        Connect-MsolService -Credential $cred
    }
    Write-Output "connected"
    $users = Get-MsolUser 
    $userfound = $users | where-object {$_.UserPrincipalName -eq $userUPN}
    if ($userfound) {
        Write-Output "user azrun already created"
    }
    else {
        $user = New-MsolUser -UserPrincipalName $userUPN -DisplayName "Azure Runbook Account" -PreferredDataLocation "US"
        $user | Set-MsolUser -UsageLocation "US"
    }
}
catch {
    Write-Error $Error[0].Exception.Message
}
