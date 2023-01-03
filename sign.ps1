$files = Get-ChildItem -Recurse

$certVariable = Get-Item -Path 'Env:CERT_VARIABLE'

foreach ($file in $files) {
    Set-AuthenticodeSignature -FilePath $file.FullName -Certificate $certVariable.Value
}
