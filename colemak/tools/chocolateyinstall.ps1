$ErrorActionPreference = 'Stop';

$packageName= 'colemak'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url        = 'https://skozl.com/s/colemak-caps.zip'

$locale = 'EN'
if ($env:chocolateyPackageParameters -match "locale=co") {
    $locale = 'CO'
}
$arch = 'i386'
if (Get-ProcessorBits 64) {
    $arch = 'amd64'
}
$fileLocation = Join-Path $toolsDir "colemak ($locale)/Colemak_$arch.msi"

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'msi'
  url           = $url
  file          = $fileLocation
  silentArgs    = "/qn /norestart /l*v `"$env:TEMP\chocolatey\$($packageName)\$($packageName).MsiInstall.log`" ALLUSERS=1"
  validExitCodes= @(0, 3010, 1641)
  softwareName  = 'colemak*'
  checksum      = '08fa83e36dbb2c64cc58210330eda72d'
  checksumType  = 'md5'
}

Install-ChocolateyZipPackage @packageArgs

Get-ChildItem -recurse $toolsDir -filter setup.exe | foreach {
    $ignoreFile = $_.FullName + '.ignore'
    Set-Content -Path $ignoreFile -Value ($null)
}

Install-ChocolateyInstallPackage @packageArgs
