#!/bin/bash

# Ruta del archivo de registro de inicio de sesión
auth_log="/var/log/auth.log"

# Comprobar si se han realizado intentos de inicio de sesión con credenciales incorrectas
failed_login_attempts=$(grep "Failed password" "$auth_log" | wc -l)
if [ "$failed_login_attempts" -gt 0 ]; then
  echo "Se han detectado intentos de inicio de sesión con credenciales incorrectas:"
  grep "Failed password" "$auth_log"
  echo ""
fi

# Comprobar si se han realizado intentos de inicio de sesión desde ubicaciones no autorizadas
unauthorized_login_attempts=$(grep "Failed password" "$auth_log" | grep -Eo "from \S+" | grep -v "from 127.0.0.1\|from ::1" | wc -l)
if [ "$unauthorized_login_attempts" -gt 0 ]; then
  echo "Se han detectado intentos de inicio de sesión desde ubicaciones no autorizadas:"
  grep "Failed password" "$auth_log" | grep -Eo "from \S+" | grep -v "from 127.0.0.1\|from ::1"
  echo ""
fi

echo "Análisis de seguridad completo."