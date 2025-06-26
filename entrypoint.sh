#!/bin/bash

cd /var/www/webman-app

# Chờ MySQL container sẵn sàng
echo "⏳ Đợi MySQL khởi động..."
until nc -z -v -w30 mysql 3306
do
  echo "❗ Chưa kết nối được MySQL, đợi tiếp..."
  sleep 2
done
echo "✅ Đã kết nối được MySQL"

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
