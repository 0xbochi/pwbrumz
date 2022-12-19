#> return the momory of the computer in GB

return Get-CimInstance -ClassName "win32_physicalmemory" | select-object -ExpandProperty Capacity | Measure-Object -Sum | select-object @{name = "memorySize"; expression = { "$($_.sum/"1GB")GB" } }  