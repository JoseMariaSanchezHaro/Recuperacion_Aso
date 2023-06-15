#!/bin/bash

# Actualizar los repositorios de paquetes
echo "Actualizando los repositorios de paquetes..."
sudo apt-get update
echo ""

# Actualizar los paquetes instalados
echo "Actualizando los paquetes instalados..."
sudo apt-get upgrade -y
echo ""

# Solucionar posibles fallos de actualización
echo "Solucionando posibles fallos de actualización..."
sudo apt-get install -f
echo ""

# Eliminar los paquetes que ya no son necesarios
echo "Eliminando los paquetes que ya no son necesarios..."
sudo apt-get autoremove --purge -y
echo ""

# Limpiar la caché de paquetes descargados
echo "Limpiando la caché de paquetes descargados..."
sudo apt-get clean
echo ""

echo "El sistema ha sido actualizado y limpiado correctamente."