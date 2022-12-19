function module_helper_reader([string]$moduleName){
    Get-Content "modules/$moduleName.ps1" | Where-Object { $_ -match '^#>' } | ForEach-Object { $_ -replace '^#>', '' }

}

function module_lister(){
    Get-ChildItem -File -Path ".\modules\" | Select-Object -ExpandProperty Name | ForEach-Object {
        $parts = $_ -split "\."
        $parts[0]
    }

}

