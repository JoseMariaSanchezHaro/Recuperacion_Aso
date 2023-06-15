#!/bin/bash

# Mostrar interfaces de red detectadas
echo "Interfaces de red detectadas:"
echo "-----------------------------"
ip addr show | awk '/^[0-9]+:/ {print substr($2, 1, length($2)-1)}'
echo ""

# Obtener la interfaz de red deseada
read -p "Ingresa el nombre de la interfaz de red deseada: " interface
echo ""

# Obtener la configuración de red deseada
read -p "Ingresa la dirección IP: " ip_address
read -p "Ingresa la máscara de red: " subnet_mask
read -p "Ingresa la puerta de enlace: " gateway
read -p "Ingresa el servidor DNS primario: " dns_primary
read -p "Ingresa el servidor DNS secundario: " dns_secondary
echo ""

# Generar el archivo de configuración de red
cat > /etc/network/interfaces <<EOF
auto lo
iface lo inet loopback

auto $interface
iface $interface inet static
    address $ip_address
    netmask $subnet_mask
    gateway $gateway
    dns-nameservers $dns_primary $dns_secondary
EOF

echo "Archivo de configuración de red generado correctamente."