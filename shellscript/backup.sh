#!/bin/bash

# Obtener el nombre de usuario
read -p "Ingresa el nombre de usuario cuyo directorio personal deseas respaldar: " username
echo ""

# Verificar si el usuario existe
if id "$username" &>/dev/null; then
  echo "El usuario $username existe."
  echo ""

  # Directorio de origen y destino para la copia de seguridad
  source_dir="/home/$username"
  backup_dir="/home/usuario/Escritorio"  # Reemplaza con la ruta deseada

  # Nombre y ruta del archivo de respaldo
  backup_file="$backup_dir/backup_$username.tar.gz"

  # Comprobar si el directorio de destino existe
  if [ ! -d "$backup_dir" ]; then
    echo "El directorio de destino $backup_dir no existe. Creándolo..."
    mkdir -p "$backup_dir"
  fi

  # Realizar la copia de seguridad comprimiendo el directorio
  echo "Creando copia de seguridad de $source_dir..."
  tar -czvf "$backup_file" "$source_dir"

  echo "Copia de seguridad creada exitosamente en $backup_file."
else
  echo "El usuario $username no existe."
fi