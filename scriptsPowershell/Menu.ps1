# Definir las opciones del menú
$options = @{
    "1" = "Script 1: Obtener información del Hardware "
    "2" = "Script 2: Gestión de red"
    "3" = "Script 3: Dominio"
    "4" = "Script 4: Procesos"
    "5" = "Script 5: Servicios"
    "6" = "Script 6: Usuarios"
    "7" = "Script 7: Actualizaciones"
    "8" = "Script 8: Seguridad"
    "0" = "Salir"
}

# Función para ejecutar el script seleccionado
function RunScript($scriptNumber) {
    switch ($scriptNumber) {
        "1" {
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
        }   
        "2" {
            # Mostrar las interfaces de red detectadas
                Get-NetAdapter | Format-Table -Property Name, InterfaceDescription, MacAddress

            # Solicitar al usuario que ingrese el nombre de la interfaz
                $interfaceName = Read-Host "Ingresa el nombre de la interfaz de red que deseas configurar"

            # Obtener la interfaz seleccionada
                $interface = Get-NetAdapter | Where-Object { $_.Name -eq $interfaceName }

                if ($interface) {
                     Write-Host "Interfaz seleccionada: $($interface.Name)"

                 # Solicitar al usuario que elija una opción de configuración
                     $option = Read-Host "Selecciona una opción de configuración:`n1) DHCP`n2) Estática"

                     if ($option -eq "1") {
                      # Configurar por DHCP
                      Write-Host "Configurando la interfaz por DHCP..."
                    Set-NetIPInterface -InterfaceAlias $interface.Name -Dhcp Enabled
                    Write-Host "La interfaz ha sido configurada por DHCP."
                } elseif ($option -eq "2") {
                    # Configurar estáticamente
                 $ipAddress = Read-Host "Ingresa la dirección IP"
                $subnetMask = Read-Host "Ingresa la máscara de subred"
                $defaultGateway = Read-Host "Ingresa la puerta de enlace (default gateway)"
                $dnsServers = Read-Host "Ingresa los servidores DNS (separados por coma)"

                # Configurar la interfaz estáticamente
                Write-Host "Configurando la interfaz estáticamente..."
                Set-NetIPAddress -InterfaceAlias $interface.Name -IPAddress $ipAddress -PrefixLength $subnetMask
                Set-NetIPInterface -InterfaceAlias $interface.Name -DefaultGateway $defaultGateway
                Set-DnsClientServerAddress -InterfaceAlias $interface.Name -ServerAddresses $dnsServers.Split(",")
                Write-Host "La interfaz ha sido configurada estáticamente."
            } else {
        Write-Host "Opción no válida."
            }
               } else {
                Write-Host "No se encontró la interfaz con el nombre especificado."
        }

        }
        "3" {
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
        }
        "4" {
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
        }
        "5" {
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
        }
        "6" {
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
        }
        "7" {
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
        }
        "8" {
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
        }
    }
}

# Función para mostrar el menú
function ShowMenu() {
    Clear-Host
    Write-Host "Proyecto PowerShell - Menú Principal"
    Write-Host "-----------------------------------"
    $options.Keys | ForEach-Object {
        Write-Host "$_ - $options[$_]"
    }
    Write-Host
    Write-Host "Ingrese el número del script que desea ejecutar (0 para salir):"
}

# Bucle principal del menú
do {
    ShowMenu
    $selection = Read-Host

    if ($options.ContainsKey($selection)) {
        if ($selection -eq "0") {
            Write-Host "Saliendo del menú principal..."
        }
        else {
            Write-Host "Ejecutando $($options[$selection])"
            RunScript $selection
            Write-Host
            Write-Host "Presione cualquier tecla para volver al menú principal..."
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        }
    }
    else {
        Write-Host "Opción inválida. Por favor, seleccione una opción válida del menú."
        Write-Host
        Write-Host "Presione cualquier tecla para continuar..."
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
} while ($selection -ne "0")