#> get network info like IP address, subnet mask, default gateway and DNS servers

$ComputerName = $env:COMPUTERNAME
$NetworkAdapter = Get-NetAdapter | Where-Object {$_.Status -eq 'Up' -and $_.PhysicalMediaType -eq '802.3'}
$IPv4Address = $NetworkAdapter | Get-NetIPAddress -AddressFamily IPv4 | Select-Object -ExpandProperty IPAddress
$SubnetMask = $NetworkAdapter | Get-NetIPAddress -AddressFamily IPv4 | Select-Object -ExpandProperty PrefixLength
$DefaultGateway = (Get-NetRoute -DestinationPrefix 0.0.0.0/0 -InterfaceAlias $NetworkAdapter.InterfaceAlias).NextHop
$DNSServers = (Get-DnsClientServerAddress -InterfaceAlias $NetworkAdapter.InterfaceAlias).ServerAddresses

Write-Host "Network Information for $ComputerName : IPv4 Address: $IPv4Address, Subnet Mask: $SubnetMask, Default Gateway: $DefaultGateway, DNS Servers: $DNSServers" -ForegroundColor Green