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
    [switch]$help,

    [alias("v")]
    [switch]$version

)
try{
    Import-Module .\parsing\parsing.ps1 -Force
}catch{
    Write-Error -Message "An error occurred: $($_.Exception.Message)"
    Write-Error -Message "You should try to run the script with powershell.exe .\main.ps1"
}


# this boolean is used to know if the user want to run a command or a module
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

function server_multiple([string]$file, [string]$moduleName, [string]$command){
    # Read the list of servers from a text file
    $servers = Get-Content "config/$file"
    $cred = Get-Credential

    # Loop through the list of servers and run the Invoke-Command cmdlet on each server
    $servers | ForEach-Object {
        # Specify the credentials to use for authentication
        if ($comSwitch -eq 1){
            Invoke-Command -ComputerName "$serverName" -Authentication Kerberos -Credential $cred -ScriptBlock { $command }
        }else{
            
        # Run the script on the server
        Invoke-Command -ComputerName "$_" -Authentication Kerberos -Credential $cred -FilePath "modules/$moduleName"

        }
    

    }
}


if($version){

    Write-Host "Version 0.1.0"
}


#List all modules
if($modules){
    Write-Host "Use the command -doc xor -d followed by the name of the module to get more informations"
    Write-Host "Example :  -d hello_world"
    Write-Host "Here are all loaded modules : "
    module_lister
}

#Get documentation about specific module
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
