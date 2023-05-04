# Pedir datos al usuario
$nombre = Read-Host "Introduce el nombre de usuario"
$pass = Read-Host "Introduce la contraseña" -AsSecureString
$departamento = Read-Host "Introduce el departamento"
$movil = Read-Host "Introduce el número de móvil"
$correo = Read-Host "Introduce la dirección de correo electrónico"

# Crear el usuario
New-ADUser -Name $nombre -AccountPassword $pass -Department $departamento -MobilePhone $movil -EmailAddress $correo -Path "OU=Usuarios,DC=dominio,DC=com" -Enabled $true

# Agregar el usuario al grupo de Usuarios del Dominio
Add-ADGroupMember -Identity "Usuarios del Dominio" -Members $nombre
# Mostrar menú de selección de privilegios
Write-Host "Selecciona los privilegios a asignar al usuario:"
Write-Host "1. Operador de cuenta"
Write-Host "2. Administrador"
Write-Host "3. Operador de copias de seguridad"
Write-Host "4. Operador de configuración de red"
Write-Host "5. Operador de impresión"
$opcion = Read-Host "Introduce el número de opción (pulsa Enter para omitir)"

# Asignar privilegios seleccionados
switch ($opcion) {
    "1" { Add-ADGroupMember -Identity "Operador de cuenta" -Members $nombre }
    "2" { Add-ADGroupMember -Identity "Administrador" -Members $nombre }
    "3" { Add-ADGroupMember -Identity "Operador de copias de seguridad" -Members $nombre }
    "4" { Add-ADGroupMember -Identity "Operador de configuración de red" -Members $nombre }
    "5" { Add-ADGroupMember -Identity "Operador de impresión" -Members $nombre }
    default { Write-Host "No se han asignado privilegios" }
}