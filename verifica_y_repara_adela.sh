#!/bin/bash

echo "🔍 Verificando si ADELA responde correctamente..."

STATUS=$(curl -s -o /dev/null -w "%{http_code}" https://adela-webhook-production.up.railway.app/)

if [ "$STATUS" == "200" ]; then
  echo "✅ ADELA está online y funcionando correctamente (status $STATUS)."
else
  echo "❌ ADELA aún no responde correctamente (status $STATUS)."
  echo "🔁 Iniciando proceso de recuperación..."

  echo "🧲 Haciendo git pull para sincronizar con el repositorio..."
  git pull origin master --rebase

  echo "📂 Verificando archivos sin commit..."
  git add .
  git commit -m "🛠️ Script de autoreparación ejecutado tras error $STATUS en producción" || echo "Nada que commitear."

  echo "🚀 Haciendo push al repositorio para forzar redeploy en Railway..."
  git push origin master

  echo "⏳ Espera unos segundos y vuelve a visitar:"
  echo "🌐 https://adela-webhook-production.up.railway.app/"
fi
