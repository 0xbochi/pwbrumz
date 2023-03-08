#> deletes .cab files in the Windows update folder on a server

$UpdateFolder = "C:\Windows\SoftwareDistribution\Download"
$CabFiles = Get-ChildItem -Path $UpdateFolder -Filter *.cab -Recurse

foreach ($File in $CabFiles) {
    Write-Host "Deleting $File ..."
    Remove-Item -Path $File.FullName -Force
}

Write-Host "Done."
