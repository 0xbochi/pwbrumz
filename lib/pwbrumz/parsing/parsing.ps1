#this function will parse the modules and return the help text
function module_helper_reader([string]$moduleName){
    Get-Content "modules/$moduleName.ps1" | Where-Object { $_ -match '^#>' } | ForEach-Object { $_ -replace '^#>', '' }

}

# This function will list all modules
function module_lister(){
    Get-ChildItem -File -Path ".\modules\" | Select-Object -ExpandProperty Name | ForEach-Object {
        $parts = $_ -split "\."
        $parts[0]
    }

}

