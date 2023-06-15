# Obtener los eventos del registro de seguridad
$events = Get-WinEvent -FilterHashtable @{LogName='Security'; ID=4625,4626,4627,4628,4634,5140,5152; StartTime=(Get-Date).AddDays(-7)} -MaxEvents 100

# Definir patrones de búsqueda para eventos sospechosos
$failedLogonPattern = "Logon Type:\s+(3|4|5|7|8)"
$unauthorizedLocationPattern = "Workstation Name:\s+(?!YOUR_AUTHORIZED_WORKSTATION_NAME)"
$unauthorizedAccessPattern = "Access Mask:\s+(?!(Your_Authorized_Access_Mask))"
$unauthorizedPortPattern = "Source Port:\s+(?!(Your_Authorized_Port))"

# Filtrar eventos sospechosos
$suspiciousEvents = $events | Where-Object {
    $_.Message -match $failedLogonPattern -or
    $_.Message -match $unauthorizedLocationPattern -or
    $_.Message -match $unauthorizedAccessPattern -or
    $_.Message -match $unauthorizedPortPattern
}

# Mostrar los eventos sospechosos encontrados
if ($suspiciousEvents) {
    Write-Output "Se encontraron eventos sospechosos:"
    $suspiciousEvents | ForEach-Object {
        Write-Output "Evento ID: $($_.Id)"
        Write-Output "Registro: $($_.LogName)"
        Write-Output "Fecha y hora: $($_.TimeCreated)"
        Write-Output "Mensaje: $($_.Message)"
        Write-Output "----------------------------------------"
    }
} else {
    Write-Output "No se encontraron eventos sospechosos."
}