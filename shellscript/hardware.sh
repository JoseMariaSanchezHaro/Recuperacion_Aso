#!/bin/bash

# Información del procesador
echo "Información del procesador:"
echo "-------------------------"
cat /proc/cpuinfo | grep "model name" | uniq
echo ""

# Información de la memoria
echo "Información de la memoria:"
echo "-----------------------"
echo "Memoria total: $(grep MemTotal /proc/meminfo | awk '{print $2,$3}')"
echo ""

# Información del disco duro
echo "Información del disco duro:"
echo "-------------------------"
df -h | grep -E "/dev/sd|/dev/nvme" | awk '{print "Dispositivo: "$1 "\nPunto de montaje: "$6 "\nSistema de archivos: "$2 "\nCapacidad total: "$3 "\nEspacio utilizado: "$4 "\nEspacio disponible: "$5 "\n"}'