#!/bin/bash

cd /var/www/webman-app

# ⚙️ Ghi đè file cấu hình think-orm.php bằng bản dùng getenv (nếu chưa chỉnh)
ORM_CONFIG="config/think-orm.php"
if ! grep -q "getenv('DB_HOST')" "$ORM_CONFIG"; then
  echo "🔁 Cập nhật config/think-orm.php để dùng biến môi trường..."
  cp /docker-resources/config/think-orm.php "$ORM_CONFIG"
fi

# ⚙️ Ghi đè config/database.php nếu chưa dùng getenv()
DB_CONFIG="config/database.php"
if ! grep -q "getenv('DB_HOST')" "$DB_CONFIG"; then
  echo "🔁 Cập nhật config/database.php để dùng biến môi trường..."
  cp /docker-resources/config/database.php "$DB_CONFIG"
fi

# Chỉ tạo nếu chưa tồn tại (để không ghi đè khi người dev chỉnh sửa thủ công)
if [ ! -f app/controller/UserController.php ]; then
  cp /docker-resources/controller/UserController.php app/controller/UserController.php
fi

if [ ! -f app/model/User.php ]; then
  cp /docker-resources/model/User.php app/model/User.php
fi

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

# Cài swagger-php nếu chưa có
if [ ! -f "vendor/bin/openapi" ]; then
  echo "📦 Cài swagger-php..."
  composer require zircote/swagger-php --dev
fi

# 👉 Tạo alias support\Model nếu chưa có
BOOTSTRAP="config/bootstrap.php"
if ! grep -q "class_alias(\\\\think\\\\Model::class" "$BOOTSTRAP"; then
  echo "👉 Thêm class_alias support\\Model vào bootstrap"
  echo "class_alias(\\think\\Model::class, \\support\\Model::class);" >> "$BOOTSTRAP"
fi

# 📄 Ghi đè BaseDoc và Swagger route (luôn cập nhật từ docker-resources để dễ bảo trì)
echo "📄 Ghi đè BaseDoc, route và swagger-initializer.js..."
mkdir -p app/swagger
mkdir -p config/routes
cp /docker-resources/swagger/BaseDoc.php app/swagger/BaseDoc.php
cp /docker-resources/swagger/route.php config/routes/swagger.php
cp /docker-resources/swagger/swagger-initializer.custom.js public/swagger/ui/swagger-initializer.js

# 📄 Copy các file route từ docker-resources...
echo "📄 Copy các file route từ docker-resources..."

# Tạo thư mục nếu chưa có (phòng hờ)
mkdir -p config/routes

# Ghi đè file route từ docker-resources
cp /docker-resources/routes/swagger.php config/routes/swagger.php
cp /docker-resources/routes/api.php config/routes/api.php

# Thêm dòng import nếu chưa có trong config/route.php
ROUTE_MAIN=config/route.php

if ! grep -q "routes/api.php" "$ROUTE_MAIN"; then
  echo "require_once __DIR__ . '/routes/api.php';" >> "$ROUTE_MAIN"
fi

if ! grep -q "routes/swagger.php" "$ROUTE_MAIN"; then
  echo "require_once __DIR__ . '/routes/swagger.php';" >> "$ROUTE_MAIN"
fi

# 📥 Tải Swagger UI nếu chưa có
SWAGGER_UI_DIR="public/swagger/ui"
if [ ! -f "$SWAGGER_UI_DIR/index.html" ]; then
  echo "📥 Tải Swagger UI..."
  mkdir -p "$SWAGGER_UI_DIR"
  curl -L https://github.com/swagger-api/swagger-ui/archive/master.zip -o /tmp/swagger.zip
  unzip /tmp/swagger.zip -d /tmp
  mv /tmp/swagger-ui-master/dist/* "$SWAGGER_UI_DIR/"
  rm -rf /tmp/swagger*

  echo "🔧 Sửa đường dẫn trong Swagger UI index.html..."
  sed -i 's|href="swagger-ui.css"|href="/swagger/ui/swagger-ui.css"|g' "$SWAGGER_UI_DIR/index.html"
  sed -i 's|href="index.css"|href="/swagger/ui/index.css"|g' "$SWAGGER_UI_DIR/index.html"
  sed -i 's|src="swagger-ui-bundle.js"|src="/swagger/ui/swagger-ui-bundle.js"|g' "$SWAGGER_UI_DIR/index.html"
  sed -i 's|src="swagger-ui-standalone-preset.js"|src="/swagger/ui/swagger-ui-standalone-preset.js"|g' "$SWAGGER_UI_DIR/index.html"
  sed -i 's|src="swagger-initializer.js"|src="/swagger/ui/swagger-initializer.js"|g' "$SWAGGER_UI_DIR/index.html"
fi

# 🔁 Thay thế swagger-initializer.js bằng file tùy chỉnh từ docker-resources
echo "🔧 Ghi đè swagger-initializer.js từ docker-resources"
cp /docker-resources/swagger/swagger-initializer.custom.js "$SWAGGER_UI_DIR/swagger-initializer.js"

# ⚙️ Sửa index.html trỏ đúng vào swagger.json
if grep -q "petstore.swagger.io" "$SWAGGER_UI_DIR/index.html"; then
  sed -i 's|https://petstore.swagger.io/v2/swagger.json|../swagger.json|' "$SWAGGER_UI_DIR/index.html"
fi

# 🧪 Generate Swagger JSON (nếu có file BaseDoc hoặc Controller có @OA)
echo "🔍 Kiểm tra file PHP trong thư mục app để generate swagger.json..."
FILE_COUNT=$(find app -type f -name "*.php" | wc -l)

if [ "$FILE_COUNT" -gt 0 ]; then
  echo "🧪 Đã tìm thấy $FILE_COUNT file PHP, đang generate swagger.json..."
  ./vendor/bin/openapi --bootstrap config/bootstrap.php app -o public/swagger/swagger.json
else
  echo "⚠️ Không tìm thấy controller nào trong thư mục app, không tạo swagger.json."
  # Tạo file rỗng để tránh lỗi 404 khi Swagger UI tải swagger.json
  echo '{}' > public/swagger/swagger.json
fi

# 🗄️ Chạy file SQL khởi tạo bảng (nếu có)
if [ -f "/init.sql" ]; then
  echo "🗄️ Đang import file init.sql..."
  mysql -h "$DB_HOST" -uwebman -p1234 webman_db < /init.sql
fi

# 🚀 Khởi động Webman
php start.php start
if [ $? -ne 0 ]; then
  echo "❌ Khởi động Webman thất bại!"
  exit 1
fi
