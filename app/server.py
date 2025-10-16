from flask import Flask
import os

app = Flask(__name__)

@app.route('/')
def hello():
    msg = os.getenv('APP_MESSAGE', 'Hello, World from EKS!')
    return f"<h1>{msg}</h1>\n<p>Version: {os.getenv('APP_VERSION', 'dev')}</p>\n"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=int(os.getenv('PORT', '8080')))
