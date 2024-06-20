# 使用 php:8.0-fpm-alpine 作为基础镜像  
FROM php:8.0-fpm-alpine  
# 更换apk的源到阿里云  
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && \  
    apk update && \  
    apk add --no-cache \
    tzdata  \
    bash \
    nginx \  
    autoconf \  
    g++ \  
    make \  
    libpng-dev \  
    zlib-dev \
    icu-libs \ 
    icu-dev \
    oniguruma-dev \
    libzip-dev

# 设置时区  
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 清理不再需要的apk缓存  
RUN rm -rf /var/cache/apk/*

# 安装php常见扩展  
RUN docker-php-ext-install \  
    bcmath \  
    exif \  
    gd \  
    intl \  
    mbstring \  
    mysqli \  
    opcache \  
    pdo_mysql \  
    sockets \  
    zip 


# 将nginx配置文件复制到容器中  
COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/http.d/default.conf
COPY php-fpm.conf /usr/local/etc/php-fpm.conf
COPY www.conf /usr/local/etc/php-fpm.d/www.conf 


# 设置工作目录  
WORKDIR /data/www  

# 暴露端口  
EXPOSE 80 443

# 使用CMD指令来启动nginx和php-fpm  
CMD ["/bin/sh", "-c", "php-fpm -F & nginx -g 'daemon off;'"]