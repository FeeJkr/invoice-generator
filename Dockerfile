FROM node:12

RUN apt-get update && apt-get install -y \
    libicu-dev \
    libjpeg-dev \
    libpng-dev \
    libnss3 \
    libatk-bridge2.0-0 \
    libdrm-dev \
    libxkbcommon-dev \
    libgbm-dev \
    libgtk-3-0 \
    libasound2 \
    librabbitmq-dev \
    librdkafka-dev \
    libxslt-dev \
    libzip-dev \
    libpq-dev \
    exim4-daemon-light \
    git \
    nginx \
    procps \
    supervisor \
    unzip \
    nano

RUN apt-get update \
    && apt-get install -y wget gnupg \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-stable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-freefont-ttf libxss1 \
      --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

RUN apt purge -y $PHPSIZE_DEPS \
    && apt autoremove -y --purge \
    && apt clean all

WORKDIR /app
RUN chown -R www-data:www-data /app
USER www-data
COPY --chown=www-data:www-data . .

USER root

RUN rm /etc/nginx/nginx.conf && chown -R www-data:www-data /var/www/html /run /var/lib/nginx /var/log/nginx
COPY docker/nginx.conf /etc/nginx/nginx.conf

USER www-data

EXPOSE 8080
ENTRYPOINT [ "/app/entrypoint.sh" ]