#requires -RunAsAdministrator
#requires -version 5.1
<#
.SYNOPSIS
	Invoke Intune Win32 app wrapper utility
.DESCRIPTION
	whatever, blah blah yap yap
.PARAMETER SourcePath
	Path to source installer file
.PARAMETER SourceFile 
	Name of source installer file 
.PARAMETER OutputPath
	Path to save Intune package output
.NOTES
	Place script in folder where IntuneWinAppUtil.exe resides
.EXAMPLE
	New-IntunePackage.ps1 -SourcePath "H:\SOURCES\Apps\7zip" -SourceFile "7z1900-x64.zip" -OutputPath "H:\SOURCES\APPS\IntuneWin32Apps"
#>

[CmdletBinding()]
param (
	[parameter(Mandatory=$True, HelpMessage="Path to source installer")]
		[ValidateNotNullOrEmpty()]
		[string] $SourcePath,
	[parameter(Mandatory=$True, HelpMessage="Source installer filename")]
		[ValidateNotNullOrEmpty()]
		[string] $SourceFile,
	[parameter(Mandatory=$True, HelpMessage="Path to save Intune package")]
		[ValidateNotNullOrEmpty()]
		[string] $OutputPath = ""
)

try {
	if (-not (Test-Path ".\IntuneWinAppUtil.exe")) {
		Write-Warning "Must be invoked in folder where IntuneWinAppUtil.exe resides!"
		break 
	}
	if (-not (Test-Path $SourcePath)) {
		Write-Warning "Source path not found: $SourcePath"
		break
	}
	if (-not (Test-Path (Join-Path -Path $SourcePath -ChildPath $SourceFile))) {
		Write-Warning "Source file not found: $SourceFile"
		break
	}
	.\IntuneWinAppUtil.exe -c $SourcePath -s $SourceFile -o $OutputPath
}
catch {
	Write-Error $Error[0].Exception.Message
}
