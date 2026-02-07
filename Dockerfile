FROM mcr.microsoft.com/devcontainers/base:ubuntu

RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

RUN apt-get update && \
    apt-get install -y php php-cli php-mbstring php-xml php-curl php-zip php-gd php-intl php-sqlite3 php-mysql

RUN apt-get update && apt-get install -y default-mysql-client

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /workspace