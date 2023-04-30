# Mostrar un listado de todos los procesos en ejecución ordenados de mayor a menor consumo de memoria
Get-Process | Sort-Object WorkingSet -Descending | Format-Table Id, Name, WorkingSet -AutoSize

# Preguntar si se desea obtener información detallada de un proceso específico
$answer = Read-Host "¿Desea obtener información detallada de un proceso específico? (Sí/No)"

if ($answer -eq "Sí") {
    # Pedir el nombre del proceso del que se desea obtener información detallada
    $processName = Read-Host "Ingrese el nombre del proceso del que desea obtener información detallada"

    # Obtener el proceso específico
    $process = Get-Process -Name $processName

    if ($process) {
        # Mostrar información detallada del proceso
        $process | Format-List Id, Name, CPU, WorkingSet, Responding, StartTime, TotalProcessorTime

        # Preguntar si se desea finalizar el proceso
        $answer = Read-Host "¿Desea finalizar el proceso? (Sí/No)"

        if ($answer -eq "Sí") {
            # Finalizar el proceso
            $process.Kill()
        }
    }
    else {
        Write-Host "No se encontró ningún proceso con el nombre especificado"
    }
}

# Preguntar si se desea salir del script
$answer = Read-Host "Presione cualquier tecla para salir"