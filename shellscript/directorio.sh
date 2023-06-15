#!/bin/bash

# Verificar si el servicio de directorio LDAP está instalado
dpkg -s slapd &> /dev/null

if [ $? -eq 0 ]; then
  # El servicio de directorio LDAP está instalado
  echo "El servicio de directorio LDAP está instalado en el servidor."
  echo "Información sobre el servicio de directorio LDAP:"
  echo "----------------------------------------------"
  slapcat -n 0 | grep -E "dn:|objectClass:|cn:"
else
  # El servicio de directorio LDAP no está instalado
  echo "El servicio de directorio LDAP no está instalado en el servidor."

  # Opcionalmente, iniciar instalación y configuración
  read -p "¿Deseas instalar y configurar el servicio de directorio LDAP? (s/n): " choice
  if [[ $choice == "s" || $choice == "S" ]]; then
    # Instalar el servicio de directorio LDAP
    sudo apt-get update
    sudo apt-get install slapd

    # Configurar el servicio de directorio LDAP
    sudo dpkg-reconfigure slapd

    echo "El servicio de directorio LDAP se ha instalado y configurado correctamente."
  else
    echo "No se ha realizado ninguna instalación o configuración del servicio de directorio LDAP."
  fi
fi