# Obtener el nombre del equipo
$computerName = $env:COMPUTERNAME

# Verificar si el equipo pertenece a un grupo de trabajo o a un dominio
$domain = (Get-WmiObject Win32_ComputerSystem).Domain
if ($domain -eq $null) {
    $membership = "Grupo de Trabajo"
} else {
    $membership = "Dominio: $domain"
}

# Mostrar la información del equipo
Write-Host "Nombre del equipo: $computerName"
Write-Host "Membresía: $membership"

# Solicitar al usuario que ingrese un nuevo nombre de equipo
$newName = Read-Host "Ingrese el nuevo nombre del equipo"

# Cambiar el nombre del equipo
Rename-Computer -NewName $newName -Force -Restart

# Verificar si el equipo pertenece a un grupo de trabajo para ofrecer la opción de unirse a un dominio
if ($membership -eq "Grupo de Trabajo") {
    $joinDomain = Read-Host "¿Desea unirse a un dominio? (S/N)"
    if ($joinDomain -eq "S") {
        $domainName = Read-Host "Ingrese el nombre del dominio"
        $credential = Get-Credential
        Add-Computer -DomainName $domainName -Credential $credential -Restart
    }
}