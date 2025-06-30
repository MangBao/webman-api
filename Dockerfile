FROM ubuntu:22.04

# Không hiển thị prompt khi cài tzdata
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Ho_Chi_Minh

# Cài PHP, Composer và các công cụ cần thiết
RUN apt update && apt install -y \
    php php-cli php-mbstring php-xml php-mysql php-curl php-zip \
    unzip curl git nano tzdata bash iputils-ping netcat && \
    rm -rf /var/lib/apt/lists/*

# Cài Composer toàn cục
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

# Copy file entrypoint.sh vào container và cấp quyền thực thi
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Copy thư mục chứa tài nguyên cấu hình swagger
COPY docker-resources /docker-resources

# Thư mục làm việc của Webman
WORKDIR /var/www/webman-app

# Lệnh mặc định khi container khởi động
CMD ["/entrypoint.sh"]
