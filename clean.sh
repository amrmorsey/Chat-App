#!/bin/bash
set -e

docker compose down
docker volume rm chat_app_db_data chat_app_es_data chat_app_redis_data