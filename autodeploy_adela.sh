#!/bin/bash

echo "🌸 Iniciando script automático para ADELA..."

# Ruta al proyecto (PERSONALIZA SI CAMBIA)
PROJECT_PATH="~/adela-webhook"

# Ir al proyecto
cd "$PROJECT_PATH" || { echo "❌ No se pudo entrar al proyecto"; exit 1; }

# Verificar si es un repo de git
if [ ! -d ".git" ]; then
  echo "⚠️  No es un repositorio Git. Inicializando..."
  git init
  git remote add origin https://github.com/ADELAntosdecitas/adela-webhook.git
fi

# Crear Procfile si no existe
echo "web: gunicorn main:app" > Procfile

# Crear requirements.txt
cat <<EOT > requirements.txt
flask==2.3.3
twilio==8.0.0
gunicorn==21.2.0
EOT

# Crear main.py si no existe
cat <<EOPY > main.py
from flask import Flask, request
from twilio.twiml.messaging_response import MessagingResponse

app = Flask(__name__)

@app.route("/", methods=["GET"])
def home():
    return "Servidor de ADELA funcionando correctamente 💻"

@app.route("/webhook", methods=["POST"])
def webhook():
    incoming_msg = request.form.get("Body")
    response = MessagingResponse()
    msg = response.message()
    if "hola" in incoming_msg.lower():
        msg.body("¡Hola! Soy ADELA, tu asistente virtual 😊")
    else:
        msg.body("Lo siento, no entendí tu mensaje.")
    return str(response)
EOPY

# Hacer commit y push
git add .
git commit -m "⚡ Script automático: archivos clave y despliegue Railway"
git pull --rebase origin master
git push origin master

echo "📤 Código enviado. Esperando a que Railway lo despliegue..."

# Esperar 10 segundos para que Railway tenga tiempo de hacer el deploy
sleep 10

# Verificar si la web responde correctamente
echo "🌐 Verificando URL pública..."
STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" https://adela-webhook-production.up.railway.app/)

if [ "$STATUS_CODE" == "200" ]; then
    echo "✅ ¡ADELA ya está viva y respondiendo en producción!"
else
    echo "❌ ADELA aún no responde correctamente (status $STATUS_CODE). Sigue investigando..."
fi
