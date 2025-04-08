from flask import Flask, request
from twilio.twiml.messaging_response import MessagingResponse

app = Flask(__name__)

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

@app.route("/", methods=["GET"])
def home():
    return "Servidor de ADELA funcionando correctamente 🧠"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)


