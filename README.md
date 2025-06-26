
# 🐘 Webman Docker Starter

Dự án Webman PHP Framework chạy bằng Docker, cài sẵn MySQL, Composer, ThinkORM, tự động khởi tạo database và bảng `users`. Phù hợp để phát triển API nhanh chóng.

---

## 📦 Cấu trúc thư mục

```bash
.
├── Dockerfile
├── docker-compose.yml
├── entrypoint.sh
├── php.ini
├── .env
├── mysql-init/
│   └── init.sql              # Lệnh SQL tạo bảng khi container MySQL khởi động
└── webman-app/
    ├── app/
    │   ├── controller/       # Controller API (UserController, IndexController)
    │   ├── model/            # ORM models (User.php)
    │   ├── middleware/       # Middleware
    │   └── ...
    ├── config/               # Cấu hình Webman & ThinkORM
    ├── public/               # Public root
    ├── routes/web.php        # Khai báo route API
    └── start.php
```

---

## 🚀 Cách chạy dự án

### 1. Clone repo
```bash
git clone https://github.com/your-username/webman-docker-app.git
cd webman-docker-app
```

### 2. Chạy Docker
```bash
docker compose up --build
```

- Mặc định Webman chạy ở: [http://127.0.0.1:8080](http://127.0.0.1:8080)
- MySQL chạy ở: `localhost:3306`, user: `webman`, pass: `1234`, DB: `webman_db`

---

## 🛠️ Các API đã có sẵn

### ➕ Thêm user
```http
POST /users
Content-Type: application/json

{
  "name": "Bảo",
  "email": "bao@example.com"
}
```

### 📄 Lấy danh sách user
```http
GET /users
```

### 🔍 Lấy 1 user theo ID
```http
GET /users/{id}
```

### ✏️ Cập nhật user
```http
PUT /users/{id}
```

### 🗑️ Xoá user
```http
DELETE /users/{id}
```

---

## 🧩 Các công nghệ đã dùng

| Thành phần | Mô tả |
|-----------|-------|
| Webman    | PHP high-performance framework |
| Docker    | Đóng gói môi trường & dễ deploy |
| MySQL     | Cơ sở dữ liệu |
| Composer  | Quản lý gói PHP |
| ThinkORM  | ORM mạnh mẽ tích hợp trong Webman |
| Bash      | Entrypoint tự động setup Webman và ORM |

---

## 🗂️ Gợi ý `.gitignore`

```gitignore
/vendor/
/runtime/
.env
db_data/
*.log
*.bak
.vscode/
/.idea/
```

---

## 📌 Ghi chú

- File `init.sql` sẽ tự động tạo bảng `users` khi container MySQL khởi tạo lần đầu.
- Nếu bạn muốn thêm bảng khác, chỉnh sửa file: `mysql-init/init.sql`.

---

## 💡 Tài liệu tham khảo

- Webman: https://www.workerman.net/webman
- ThinkORM: https://github.com/top-think/think-orm
- Docker Compose: https://docs.docker.com/compose/
