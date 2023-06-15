# Solicitar los datos del usuario
$nombre = Read-Host "Ingrese el nombre del usuario"
$password = Read-Host "Ingrese la contraseña" -AsSecureString
$departamento = Read-Host "Ingrese el departamento"
$movil = Read-Host "Ingrese el número de móvil"
$correo = Read-Host "Ingrese la dirección de correo"

# Crear el objeto de usuario
$newUser = @{
    'Name' = $nombre
    'SamAccountName' = $nombre
    'UserPrincipalName' = "$nombre@$env:USERDNSDOMAIN"
    'GivenName' = $nombre
    'Surname' = $nombre
    'DisplayName' = $nombre
    'Description' = $departamento
    'Department' = $departamento
    'MobilePhone' = $movil
    'EmailAddress' = $correo
    'Enabled' = $true
    'PasswordNeverExpires' = $true
    'Password' = $password
}

# Crear el usuario en el dominio
New-ADUser @newUser

# Asignar el usuario al grupo de Usuarios del Dominio
Add-ADGroupMember -Identity "Usuarios del Dominio" -Members $nombre

# Opcionalmente, asignar privilegios al usuario
$asignarPrivilegios = Read-Host "¿Desea asignar privilegios al usuario? (S/N)"
if ($asignarPrivilegios -eq "S") {
    Write-Host "Seleccione los privilegios que desea asignar al usuario:"
    Write-Host "1) Operador de cuenta"
    Write-Host "2) Administrador"
    Write-Host "3) Operador de copias de seguridad"
    Write-Host "4) Operador de configuración de red"
    Write-Host "5) Operador de impresión"
    $privilegios = Read-Host "Ingrese los números de privilegios separados por comas (por ejemplo: 1,3,5)"

    # Asignar los privilegios seleccionados al usuario
    $privileges = $privilegios -split ',' | ForEach-Object {
        switch ($_) {
            "1" { "SeSecurityPrivilege" }
            "2" { "SeMachineAccountPrivilege" }
            "3" { "SeBackupPrivilege" }
            "4" { "SeNetworkConfigurationPrivilege" }
            "5" { "SePrintOperatorPrivilege" }
        }
    }
    $privileges | ForEach-Object {
        $privilege = $_
        Set-ADUser -Identity $nombre -Replace @{ "msDS-AllowedToActOnBehalfOfOtherIdentity" = $privilege }
    }
}

Write-Host "El usuario $nombre ha sido creado en el dominio y asignado al grupo de Usuarios del Dominio."