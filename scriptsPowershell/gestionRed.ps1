# Mostrar las interfaces de red detectadas
Get-NetAdapter | Format-Table -Property Name, InterfaceDescription, MacAddress

# Solicitar al usuario que ingrese el nombre de la interfaz
$interfaceName = Read-Host "Ingresa el nombre de la interfaz de red que deseas configurar"

# Obtener la interfaz seleccionada
$interface = Get-NetAdapter | Where-Object { $_.Name -eq $interfaceName }

if ($interface) {
    Write-Host "Interfaz seleccionada: $($interface.Name)"

    # Solicitar al usuario que elija una opción de configuración
    $option = Read-Host "Selecciona una opción de configuración:`n1) DHCP`n2) Estática"

    if ($option -eq "1") {
        # Configurar por DHCP
        Write-Host "Configurando la interfaz por DHCP..."
        Set-NetIPInterface -InterfaceAlias $interface.Name -Dhcp Enabled
        Write-Host "La interfaz ha sido configurada por DHCP."
    } elseif ($option -eq "2") {
        # Configurar estáticamente
        $ipAddress = Read-Host "Ingresa la dirección IP"
        $subnetMask = Read-Host "Ingresa la máscara de subred"
        $defaultGateway = Read-Host "Ingresa la puerta de enlace (default gateway)"
        $dnsServers = Read-Host "Ingresa los servidores DNS (separados por coma)"

        # Configurar la interfaz estáticamente
        Write-Host "Configurando la interfaz estáticamente..."
        Set-NetIPAddress -InterfaceAlias $interface.Name -IPAddress $ipAddress -PrefixLength $subnetMask
        Set-NetIPInterface -InterfaceAlias $interface.Name -DefaultGateway $defaultGateway
        Set-DnsClientServerAddress -InterfaceAlias $interface.Name -ServerAddresses $dnsServers.Split(",")
        Write-Host "La interfaz ha sido configurada estáticamente."
    } else {
        Write-Host "Opción no válida."
    }
} else {
    Write-Host "No se encontró la interfaz con el nombre especificado."
}
