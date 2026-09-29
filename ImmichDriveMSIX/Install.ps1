<#
    ImmichDrive sideload installer.
    1. Trusts the ImmichDrive signing certificate (asks for admin once).
    2. Installs the MSIX matching this PC's CPU (x64 or ARM64).
    Put this script in the same folder as ImmichDrive.cer and the .msix files.
    ASCII only (Windows PowerShell 5.1).
#>
$ErrorActionPreference = "Stop"
$here = $PSScriptRoot
$cer  = Join-Path $here "ImmichDrive.cer"
$arch = if ($env:PROCESSOR_ARCHITECTURE -eq "ARM64" -or $env:PROCESSOR_ARCHITEW6432 -eq "ARM64") { "ARM64" } else { "x64" }
$msix = Get-ChildItem $here -Filter "ImmichDrive-*-$arch.msix" | Sort-Object Name -Descending | Select-Object -First 1

if (-not (Test-Path $cer)) { throw "ImmichDrive.cer not found next to this script." }
if (-not $msix) { throw "No ImmichDrive-*-$arch.msix found next to this script." }

$thumb = (New-Object System.Security.Cryptography.X509Certificates.X509Certificate2 $cer).Thumbprint
if (-not (Test-Path "Cert:\LocalMachine\TrustedPeople\$thumb")) {
    Write-Host "Trusting the ImmichDrive certificate (admin prompt)..."
    $cmd = "Import-Certificate -FilePath '$cer' -CertStoreLocation Cert:\LocalMachine\TrustedPeople | Out-Null"
    $p = Start-Process powershell -Verb RunAs -Wait -PassThru -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command $cmd"
    if ($p.ExitCode -ne 0) { throw "Certificate import failed or was cancelled." }
}

Write-Host "Installing $($msix.Name)..."
Add-AppxPackage -Path $msix.FullName -ForceUpdateFromAnyVersion
Write-Host "Done. Open ImmichDrive from the Start menu, then enter your Immich server URL and API key."
