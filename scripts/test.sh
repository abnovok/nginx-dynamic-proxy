#!/bin/bash

# Цвета для вывода в терминал
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0;0m' # No Color

echo -e "${BLUE}=== ЗАПУСК ВЕРИФИКАЦИИ СТЕНДА NGINX PROXY ===${NC}\n"

# Функция для красивого вывода ответа (проверяет наличие jq)
print_json() {
    if command -v jq &> /dev/null; then
        echo "$1" | jq .
    else
        echo "$1"
    fi
}

# --- ТЕСТ 1: Длинная цепочка (Запрос на nginx-1) ---
echo -e "${GREEN}[ТЕСТ 1] Запрос через полную цепочку (nginx-1 -> nginx-2 -> nginx-3 -> app)${NC}"
echo "Выполняем: curl http://localhost:8081/"
RESPONSE1=$(curl -s http://localhost:8081/)
print_json "$RESPONSE1"
echo -e "---------------------------------------------------------\n"

# --- ТЕСТ 2: Короткая цепочка (Запрос напрямую на nginx-3) ---
echo -e "${GREEN}[ТЕСТ 2] Запрос в обход первых нод напрямую на финальный nginx-3 (nginx-3 -> app)${NC}"
echo "Выполняем: curl http://localhost:8083/"
RESPONSE2=$(curl -s http://localhost:8083/)
print_json "$RESPONSE2"
echo -e "---------------------------------------------------------\n"

# --- ТЕСТ 3: Проверка защиты от IP Spoofing ---
echo -e "${RED}[ТЕСТ 3] Попытка подмены IP (IP Spoofing) через заголовок X-Forwarded-For${NC}"
echo "Посылаем фейковый IP '9.9.9.9' на входную ноду nginx-1..."
echo "Выполняем: curl -H 'X-Forwarded-For: 9.9.9.9' http://localhost:8081/"
RESPONSE3=$(curl -s -H "X-Forwarded-For: 9.9.9.9" http://localhost:8081/)
print_json "$RESPONSE3"

echo -e "\n${BLUE}=== ПРОВЕРКА ЗАВЕРШЕНА ===${NC}"
echo "Вы можете выполнить 'docker compose logs nginx-1' чтобы увидеть логи логики GEO/MAP."