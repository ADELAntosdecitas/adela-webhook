#!/bin/bash

echo "🚀 Iniciando despliegue de ADELA..."

# Navegar a la carpeta del proyecto
cd "G:/Otros ordenadores/HUAWEI MATEBOOK 2020/MIS DOCUMENTOS 2020/PROYECTOS - FREELOS/ADELA - ADELANTO DE CITAS VISA USA/BOT ADELA/adela-webhook" || exit

# Crear Procfile si no existe
if [ ! -f "Procfile" ]; then
  echo "web: gunicorn main:app" > Procfile
  echo "✅ Procfile creado."
fi

# Asegurar que gunicorn esté en requirements.txt
if ! grep -q "gunicorn" requirements.txt; then
  echo "gunicorn==21.2.0" >> requirements.txt
  echo "✅ Gunicorn añadido a requirements.txt."
fi

# Git commit & push
git pull origin master
git add .
git commit -m "Deploy automático con Procfile y gunicorn"
git push

echo "✅ Código subido a GitHub. Espera a que Railway lo despliegue automáticamente."
