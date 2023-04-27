# Obtener el nombre del equipo
$computerName = $env:COMPUTERNAME

# Obtener la información de membresía del equipo
$domain = (Get-WmiObject -Class Win32_ComputerSystem).Domain
$workgroup = (Get-WmiObject -Class Win32_ComputerSystem).Workgroup

# Mostrar el nombre del equipo y la membresía
Write-Host "Nombre del equipo: $computerName"
if ($domain -ne $null) {
    Write-Host "Pertenece a un dominio: Sí"
    Write-Host "Dominio: $domain"
} elseif ($workgroup -ne $null) {
    Write-Host "Pertenece a un grupo de trabajo: Sí"
    Write-Host "Grupo de trabajo: $workgroup"
} else {
    Write-Host "Pertenece a un dominio: No"
    Write-Host "Grupo de trabajo: No"
}

# Preguntar si se desea cambiar el nombre del equipo
$changeName = Read-Host "¿Desea cambiar el nombre del equipo? (Sí/No)"
if ($changeName -eq "Sí") {
    $newName = Read-Host "Ingrese el nuevo nombre del equipo"
    Rename-Computer -NewName $newName -Force -Restart
    Write-Host "El nombre del equipo ha sido cambiado a $newName. El equipo se reiniciará."
}

# Preguntar si se desea crear un nuevo dominio si el equipo pertenece a un grupo de trabajo
if ($workgroup -ne $null) {
    $createDomain = Read-Host "¿Desea crear un nuevo dominio? (Sí/No)"
    if ($createDomain -eq "Sí") {
        $newDomainName = Read-Host "Ingrese el nombre del nuevo dominio"
        Add-Computer -DomainName $newDomainName
        Write-Host "El equipo ha sido unido al nuevo dominio $newDomainName. El equipo se reiniciará."
    }
}