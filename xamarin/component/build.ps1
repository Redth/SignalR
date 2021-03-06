
# URL for downloading the xamarin-component packaging tools
$xpkgUrl = "https://components.xamarin.com/submit/xpkg"

# Download component tools to a predefined location under the current path
$xamCompDir = ($PSScriptRoot + "\xamarin-component\")
$xamCompZip = ($PSScriptRoot + "\xamarin-component.zip")

Write-Host "Xamarin Component Build Script..."

if ([System.IO.Directory]::Exists($xamCompDir))
{
	Write-Host (" - Cleaning up old component build tools (" + $xamCompDir + ")...")
	Remove-Item -Recurse -Force $xamCompDir
}

if (-not [System.IO.Directory]::Exists($xamCompDir))
{	
	Write-Host (" - Creating directory for component build tools (" + $xamCompDir + ")...")
	[System.IO.Directory]::CreateDirectory($xamCompDir)
}

# Download a new copy of the component build tools
Write-Host (" - Downloading latest Component Build Tools (" + $xpkgUrl + ")...")
$webClient = New-Object System.Net.WebClient
$webClient.DownloadFile($xpkgUrl, $xamCompZip)

# Extract the downloaded build tools
Write-Host (" - Extracting component build tools (" + $xamCompDir + ")...")
$shellApp = New-Object -com Shell.Application
$zipFile = $shellApp.Namespace($xamCompZip)
$unzipDest = $shellApp.namespace($xamCompDir)
$unzipDest.Copyhere($zipFile.Items())

# Delete the original zip file
if ([System.IO.File]::Exists($xamCompZip))
{
	Write-Host (" - Deleting temporary zip file (" + $xamCompZip + ")...")
	[System.IO.File]::Delete($xamCompZip)
}

# Now actually build the component
Write-Host " - Building Component from component.yaml..."
& ($xamCompDir + "\xamarin-component.exe") ("package") ($PSScriptRoot)

# Clean up the component tools we used
if ([System.IO.Directory]::Exists($xamCompDir))
{	Write-Host " - Cleaning up Xamarin Component Tools..."
	Remove-Item -Recurse -Force $xamCompDir
}

Write-Host "Done."
