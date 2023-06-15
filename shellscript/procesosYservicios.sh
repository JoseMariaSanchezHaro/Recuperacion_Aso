#!/bin/bash

# Obtener el nombre del proceso o servicio
read -p "Ingresa el nombre del proceso o servicio: " process_name
echo ""

# Obtener información relevante del proceso o servicio
echo "Información del proceso o servicio ($process_name):"
echo "----------------------------------------------"
ps aux | grep -v grep | grep $process_name

# Opcionalmente, detener o iniciar el proceso o servicio
read -p "¿Deseas detener o iniciar el proceso o servicio ($process_name)? (s/n): " choice
if [[ $choice == "s" || $choice == "S" ]]; then
  # Verificar si el proceso o servicio está en ejecución
  ps aux | grep -v grep | grep $process_name &> /dev/null
  if [ $? -eq 0 ]; then
    # El proceso o servicio está en ejecución, se detiene
    sudo systemctl stop $process_name
    echo "El proceso o servicio ($process_name) se ha detenido."
  else
    # El proceso o servicio no está en ejecución, se inicia
    sudo systemctl start $process_name
    echo "El proceso o servicio ($process_name) se ha iniciado."
  fi
else
  echo "No se ha realizado ninguna acción sobre el proceso o servicio ($process_name)."
fi