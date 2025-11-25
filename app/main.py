from flask import Flask, request, jsonify
from .ai_backend import ai_reply

app = Flask(__name__)

@app.route('/')
def index():
    return jsonify({
        "message": "Servicio de IA funcionando correctamente"
    }), 200


@app.route('/api/reply', methods=['POST'])
def reply():
    data = request.get_json(silent=True) or {}
    prompt = data.get('prompt', '')
    reply_text = ai_reply(prompt)
    return jsonify({"reply": reply_text}), 200


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)
