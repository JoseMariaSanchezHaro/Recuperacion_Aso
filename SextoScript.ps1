# Solicitamos el nombre del servicio
$serviceName = Read-Host "Introduce el nombre del servicio"

# Obtenemos el servicio
$service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue

if($service){
    # Mostramos información relevante del servicio
    $service | Select-Object Name, DisplayName, Status, StartType, Description
    
    # Verificamos si el servicio está en ejecución
    if($service.Status -ne "Running"){
        # Preguntamos si se desea iniciar el servicio
        $answer = Read-Host "El servicio no se está ejecutando. ¿Deseas iniciarlo? (Sí/No)"
        if($answer -eq "Sí"){
            Start-Service -InputObject $service
            Write-Host "El servicio $serviceName ha sido iniciado."
        }
    }
    
    # Verificamos si el servicio se inicia automáticamente con el sistema
    if($service.StartType -ne "Automatic"){
        # Preguntamos si se desea cambiar el modo de inicio a automático
        $answer = Read-Host "El servicio no se inicia automáticamente con el sistema. ¿Deseas cambiar el modo de inicio a automático? (Sí/No)"
        if($answer -eq "Sí"){
            Set-Service -InputObject $service -StartupType Automatic
            Write-Host "El servicio $serviceName se iniciará automáticamente con el sistema."
        }
    }
}
else{
    Write-Host "El servicio $serviceName no existe."
}

# Pedimos que se presione cualquier tecla para salir
Read-Host "Presiona cualquier tecla para salir..."