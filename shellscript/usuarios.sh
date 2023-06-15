#!/bin/bash

# Obtener los datos del nuevo usuario
read -p "Nombre de usuario: " username
read -p "Contraseña: " password
read -p "Grupo: " group
read -p "Número de móvil: " mobile
read -p "Correo electrónico: " email

# Crear el usuario con los datos proporcionados
sudo useradd -m -g $group -s /bin/bash -c "$username" $username

# Establecer la contraseña del usuario
echo "$username:$password" | sudo chpasswd

# Añadir el número de móvil y correo electrónico como información adicional del usuario
sudo usermod -aG sudo $username
sudo usermod --append --comment "$mobile" --home /home/$username --shell /bin/bash $username
sudo usermod --append --comment "$email" --home /home/$username --shell /bin/bash $username

echo "El usuario $username se ha creado exitosamente."