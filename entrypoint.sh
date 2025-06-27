#!/bin/bash

cd /var/www/webman-app

# Thiết lập mặc định nếu không có ENV (hữu ích cho local)
DB_HOST=${DB_HOST:-mysql}
DB_PORT=${DB_PORT:-3306}

echo "⏳ Đợi MySQL khởi động tại $DB_HOST:$DB_PORT..."

# Đợi MySQL sẵn sàng
until nc -z "$DB_HOST" "$DB_PORT"; do
  echo "❗ Chưa kết nối được MySQL ($DB_HOST:$DB_PORT), đợi tiếp..."
  sleep 2
done

# Cài Webman nếu chưa có
if [ ! -f "start.php" ]; then
  echo "⚙️ Cài đặt Webman lần đầu..."
  composer create-project workerman/webman .
fi

# Cài ORM nếu chưa có
if [ ! -d "vendor/webman/think-orm" ]; then
  echo "📦 Cài ORM webman/think-orm..."
  composer require webman/think-orm
fi

# Chạy file SQL khởi tạo bảng (nếu có)
if [ -f "/init.sql" ]; then
  echo "🗄️ Đang import file init.sql..."
  mysql -h mysql -uwebman -p1234 webman_db < /init.sql
fi

# Khởi động Webman
echo "🚀 Khởi động Webman..."
php start.php start
