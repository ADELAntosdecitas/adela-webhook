# Script de despliegue automatizado: AriaADELAntosdecitas.sh

cd "G:/Otros ordenadores/HUAWEI MATEBOOK 2020/MIS DOCUMENTOS 2020/PROYECTOS - FREELOS/ADELA - ADELANTO DE CITAS VISA USA/BOT ADELA/adela-webhook"

echo "🚀 Iniciando despliegue de ADELA..."

git add requirements.txt Procfile

git commit -m "🔁 Script automático: archivos clave y despliegue Railway"
git pull
git push

echo "⏳ Código enviado. Esperando a que Railway lo despliegue..."
sleep 12

# Verificamos si la app responde correctamente desde Railway
STATUS=$(curl -s -o /dev/null -w "%{http_code}" https://adela-webhook-production.up.railway.app/)

if [ "$STATUS" = "200" ]; then
  echo "✅ ADELA ya responde correctamente 💬"
else
  echo "❌ ADELA aún no responde correctamente (status $STATUS). Sigue investigando..."
fi
