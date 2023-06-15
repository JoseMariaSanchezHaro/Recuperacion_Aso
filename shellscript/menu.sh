#!/bin/bash

# Función para la opción 1
function opcion1 {
    echo "Ha seleccionado la Opción 1"
    ./hardware.sh
    echo
}

# Función para la opción 2
function opcion2 {
    echo "Ha seleccionado la Opción 2"
   ./gestionRed.sh
    echo
}

# Función para la opción 3
function opcion3 {
    echo "Ha seleccionado la Opción 3"
    ./directorio.sh
    echo
}

# Función para la opción 4
function opcion4 {
    echo "Ha seleccionado la Opción 4"
    ./procesosYservicios
    echo
}

# Función para la opción 5
function opcion5 {
    echo "Ha seleccionado la Opción 5"
    ./backup.sh
    echo
}

# Función para la opción 6
function opcion6 {
    echo "Ha seleccionado la Opción 6"
    ./usuarios.sh
    echo
}

# Función para la opción 7
function opcion7 {
    echo "Ha seleccionado la Opción 7"
    ./actualizaciones.sh
    echo
}

# Función para la opción 8
function opcion8 {
    echo "Ha seleccionado la Opción 8"
    ./seguridad.sh
    echo
}

# Menú principal
while true; do
    echo "----- Menú -----"
    echo "1. Opción 1"
    echo "2. Opción 2"
    echo "3. Opción 3"
    echo "4. Opción 4"
    echo "5. Opción 5"
    echo "6. Opción 6"
    echo "7. Opción 7"
    echo "8. Opción 8"
    echo "0. Salir"
    echo "-----------------"
    read -p "Seleccione una opción: " opcion
    echo

    case $opcion in
        1)
            opcion1
            ;;
        2)
            opcion2
            ;;
        3)
            opcion3
            ;;
        4)
            opcion4
            ;;
        5)
            opcion5
            ;;
        6)
            opcion6
            ;;
        7)
            opcion7
            ;;
        8)
            opcion8
            ;;
        0)
            echo "Saliendo del menú..."
            exit 0
            ;;
        *)
            echo "Opción inválida. Por favor, seleccione una opción válida."
            echo
            ;;
    esac
done