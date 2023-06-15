# Obtener información del procesador (Nombre, fabricante, velocidad maxima del reloj y numero de nucleos)
$cpu = Get-WmiObject -Class Win32_Processor | Select-Object Name, Manufacturer, MaxClockSpeed, NumberOfCores

# Obtener información de la memoria RAM
$mem = Get-WmiObject -Class Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum | Select-Object @{Name='CapacityGB';Expression={$_.Sum / 1GB}}, Count

# Obtener información del disco duro (filtrado para que salgan solo los discos locales, letra, almacenamiento y espacio libre)
$disk = Get-WmiObject -Class Win32_LogicalDisk | Where-Object {$_.DriveType -eq 3} | Select-Object DeviceID, Size, FreeSpace

# Mostrar la información obtenida
Write-Host "Información del procesador:"
$cpu | Format-Table -AutoSize
Write-Host ""
Write-Host "Información de la memoria RAM:"
$mem | Format-Table -AutoSize
Write-Host ""
Write-Host "Información del disco duro:"
$disk | Format-Table -AutoSize