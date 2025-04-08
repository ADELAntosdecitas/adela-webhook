#!/bin/bash

# Archivo: AriaADELAntosdecitas.sh
# Descripción: Script autónomo que verifica y repara problemas en el despliegue de ADELA
# Autor: Aria ✨

WEBHOOK_URL="https://adela-webhook-production.up.railway.app"
LOG_FILE="aria_autofix_log.txt"
NOW=$(date)

# Paso 1: Verificar disponibilidad de la URL
STATUS=$(curl -s -o /dev/null -w "%{http_code}" $WEBHOOK_URL)

if [[ "$STATUS" == "200" ]]; then
  echo "$NOW - ✅ ADELA está funcionando correctamente (status 200)" | tee -a $LOG_FILE
  exit 0
else
  echo "$NOW - ❌ ADELA falló con código $STATUS. Ejecutando rutina de reparación..." | tee -a $LOG_FILE
fi

# Paso 2: Iniciar rutina de autorreparación

# 1. Hacer pull por si hay cambios remotos
GIT_PULL_OUTPUT=$(git pull origin master 2>&1)

echo "$NOW - 💾 git pull ejecutado." | tee -a $LOG_FILE

echo "$GIT_PULL_OUTPUT" | tee -a $LOG_FILE

# 2. Hacer commit si hay archivos modificados o nuevos
if [[ -n $(git status --porcelain) ]]; then
  git add .
  git commit -m "🌟 Auto reparación AriaADELAntosdecitas por fallo detectado ($STATUS)"
  echo "$NOW - 🖊️ Commit creado." | tee -a $LOG_FILE
else
  echo "$NOW - ✅ Nada que commitear." | tee -a $LOG_FILE
fi

# 3. Hacer push
GIT_PUSH_OUTPUT=$(git push 2>&1)

if [[ $? -eq 0 ]]; then
  echo "$NOW - 🚀 Push realizado con éxito." | tee -a $LOG_FILE
else
  echo "$NOW - ❌ Error al hacer push:" | tee -a $LOG_FILE
  echo "$GIT_PUSH_OUTPUT" | tee -a $LOG_FILE
fi

# 4. Esperar 30 segundos para permitir que Railway lo despliegue
sleep 30

# 5. Verificar nuevamente el estado de la URL
STATUS_AFTER=$(curl -s -o /dev/null -w "%{http_code}" $WEBHOOK_URL)

if [[ "$STATUS_AFTER" == "200" ]]; then
  echo "$NOW - 🌟 Aria autoreparación exitosa. ADELA está funcionando (status 200)" | tee -a $LOG_FILE
else
  echo "$NOW - 🛡️ ADELA sigue fallando (status $STATUS_AFTER). Requiere intervención." | tee -a $LOG_FILE
fi

exit 0
