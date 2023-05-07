# Obtener una lista de todos los equipos del dominio
$computers = Get-ADComputer -Filter *

# Recorrer la lista de equipos y obtener la última actualización instalada
foreach ($computer in $computers) {
    $hotfix = Invoke-Command -ComputerName $computer.Name -ScriptBlock {
        Get-HotFix | Where-Object { $_.Description -like "*Security Update*" } | Sort-Object InstalledOn -Descending | Select-Object -First 1
    }

    # Mostrar la información obtenida
    Write-Output "$($computer.Name): $($hotfix.HotfixId) - $($hotfix.Description) - $($hotfix.InstalledOn)"
}

# Opcionalmente, generar un informe con toda la información
$report = Read-Host "¿Desea generar un informe? (S/N)"
if ($report -eq "S") {
    $filename = Read-Host "Especifique el nombre del archivo"
    $output = $computers | ForEach-Object {
        $hotfix = Invoke-Command -ComputerName $_.Name -ScriptBlock {
            Get-HotFix | Where-Object { $_.Description -like "*Security Update*" } | Sort-Object InstalledOn -Descending | Select-Object -First 1
        }
        "$($_.Name): $($hotfix.HotfixId) - $($hotfix.Description) - $($hotfix.InstalledOn)"
    }
    $output | Out-File -FilePath $filename
}