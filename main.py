from flask import Flask, request

app = Flask(__name__)

# Ruta de prueba (GET)
@app.route("/", methods=["GET"])
def home():
    return "Servidor de ADELA funcionando correctamente 💻", 200

# Ruta para mensajes de Twilio (POST)
@app.route("/webhook", methods=["POST"])
def webhook():
    try:
        incoming_msg = request.values.get('Body', '').lower()
        print("Mensaje recibido:", incoming_msg)

        if "hola" in incoming_msg:
            return "¡Hola! Soy ADELA, tu asistente para adelantar citas de visa a USA. ¿En qué puedo ayudarte?", 200
        elif "precio" in incoming_msg:
            return "💰 La tarifa actual es de $90 por un adelanto garantizado. ¿Te gustaría iniciar ahora?", 200
        elif "gracias" in incoming_msg:
            return "¡Con gusto! Estoy para ayudarte ✨", 200
        else:
            return "No entendí muy bien, ¿puedes repetir o escribir 'precio', 'hola' o 'gracias'? 🙏", 200

    except Exception as e:
        print("Error:", e)
        return "Error interno del servidor", 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=3000, debug=True)
