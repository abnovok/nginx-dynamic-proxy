FROM python:3.11-slim

WORKDIR /app

# Устанавливаем Flask без кэширования пакетов
RUN pip install --no-cache-dir flask==3.0.2

COPY app.py .

# Отключаем буферизацию потоков ввода-вывода для моментального вывода логов в docker logs
ENV PYTHONUNBUFFERED=1

EXPOSE 5000

CMD ["python", "app.py"]