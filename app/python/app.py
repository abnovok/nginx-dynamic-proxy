from flask import Flask, request, jsonify
import sys
import logging

app = Flask(__name__)

# Явно настраиваем логирование в stdout, чтобы docker logs читал поток в реальном времени
logging.basicConfig(
    stream=sys.stdout,
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)

@app.route('/', defaults={'path': ''})
@app.route('/<path:path>')
def catch_all(path):
    # Собираем все входящие заголовки в словарь
    headers = dict(request.headers)
    
    # Логируем факт запроса и заголовки в консоль контейнера
    app.logger.info(f"🤖 [Python App] Request from {request.remote_addr} | XFF: {headers.get('X-Forwarded-For')}")
    
    # Возвращаем JSON с отладочной информацией
    return jsonify({
        "status": "success",
        "backend": "Python / Flask",
        "perceived_remote_addr": request.remote_addr,
        "all_received_headers": headers
    }), 200

if __name__ == '__main__':
    # Запускаем на порту 5000
    app.run(host='0.0.0.0', port=5000)