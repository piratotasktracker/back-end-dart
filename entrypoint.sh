#!/bin/bash

# Создаем файл .env с переменными окружения
echo "MONGO_DB_URI=${MONGO_DB_URI}" > /app/.env
echo "JWT_SECRET_KEY=${JWT_SECRET_KEY}" >> /app/.env
echo "DB_TYPE=${DB_TYPE}" >> /app/.env

# Запускаем сервер
exec /app/bin/server
