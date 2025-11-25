from flask import Flask, request, render_template, jsonify
from .ai_backend import ai_reply

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/health')
def health():
    return jsonify({"status": "healthy", "service": "espinoza-ai", "version": "1.0.5"})

@app.route('/api/reply', methods=['POST'])
def reply():
    data = request.json or {}
    prompt = data.get('prompt', '')
    reply_text = ai_reply(prompt)
    return jsonify({"reply": reply_text})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
