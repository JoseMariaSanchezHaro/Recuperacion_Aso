# Pedir el nombre del servicio del que se desea obtener información
$serviceName = Read-Host "Ingrese el nombre del servicio del que desea obtener información"

# Obtener el servicio
$service = Get-Service -Name $serviceName

if ($service) {
    # Mostrar información del servicio
    $service | Format-List DisplayName, Status, StartType, Description

    if ($service.Status -ne "Running") {
        # Preguntar si se desea iniciar el servicio
        $answer = Read-Host "El servicio no se está ejecutando. ¿Desea iniciarlo? (Sí/No)"

        if ($answer -eq "Sí") {
            # Iniciar el servicio
            $service.Start()

            # Mostrar el estado actual del servicio
            $service | Format-Table Name, Status
        }
    }

    # Verificar si el servicio se inicia automáticamente con el inicio del sistema
    if ($service.StartType -ne "Automatic") {
        # Preguntar si se desea cambiar el modo de inicio
        $answer = Read-Host "El servicio no se inicia automáticamente con el inicio del sistema. ¿Desea cambiar el modo de inicio? (Sí/No)"

        if ($answer -eq "Sí") {
            # Cambiar el modo de inicio a automático
            Set-Service -Name $serviceName -StartupType Automatic

            # Mostrar el modo de inicio actual del servicio
            $service | Format-Table Name, StartType
        }
    }
}
else {
    Write-Host "No se encontró ningún servicio con el nombre especificado"
}

# Preguntar si se desea salir del script
$answer = Read-Host "Presione cualquier tecla para salir" 