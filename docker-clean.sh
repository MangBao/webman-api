#!/bin/bash

echo "🛑 Đang dừng và xóa container, volume..."
docker-compose down -v

echo "🧹 Dọn dẹp Docker system (container, image, volume, cache)..."
docker system prune -af
