param(
    [alias("s")]
    [string]$serverName,
    
    [alias("m")]
    [string]$moduleName,

    [alias("c")]
    [string]$command = "Default",

    [alias("f")]
    [string]$file,

    #Get documentation about specific module
    [alias("d")]
    [string]$doc,

    [alias("o")]
    [switch]$output,

    #List all modules
    [switch]$modules,

    #Get help
    [switch]$help
)

Import-Module .\parsing\parsing.ps1
[bool] $comSwitch = 0
if($command -ne "Default"){
    $comSwitch = 1   
}

function server_once([string]$serverName, [string]$moduleName, [string]$command){

    $cred = Get-Credential

    if ($comSwitch -eq 1){
        Invoke-Command -ComputerName "$serverName" -Authentication Kerberos -Credential $cred -ScriptBlock { $command }


    }else{
        Invoke-Command -ComputerName "$serverName" -Authentication Kerberos -Credential $cred -FilePath "modules/$moduleName"
    }

}

function server_multiple([string]$file, [string]$moduleName){
    # Read the list of servers from a text file
    $servers = Get-Content "config/$file"
    $cred = Get-Credential

    # Loop through the list of servers and run the Invoke-Command cmdlet on each server
    $servers | ForEach-Object {
        # Specify the credentials to use for authentication
        

        # Run the script on the server
        Invoke-Command -ComputerName "$_" -Authentication Kerberos -Credential $cred -FilePath "modules/$moduleName"
    }
}



if($modules){
    Write-Host "Use the command -doc xor -d followed by the name of the module to get more informations"
    Write-Host "Example :  -d hello_world"
    Write-Host "Here are all the modules you loaded : "
    module_lister
}

if ($PsBoundParameters.ContainsKey('doc')){
    module_helper_reader -moduleName "$doc"
}

if ($PsBoundParameters.ContainsKey('serverName') -and $PsBoundParameters.ContainsKey('file')){
    Write-Output("You can't use file and server at the same time. You should use once only")
}
elseif($PsBoundParameters.ContainsKey('serverName') -and $PsBoundParameters.ContainsKey('moduleName')){
    $r = server_once -serverName $serverName -moduleName "$moduleName.ps1"
    Write-Output $r
}elseif ($PsBoundParameters.ContainsKey('moduleName') -and $PsBoundParameters.ContainsKey('file')){
    $r = server_multiple -file "$file" -moduleName "$moduleName.ps1"
    Write-Output $r
    
}