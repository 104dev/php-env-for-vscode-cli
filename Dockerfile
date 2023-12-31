FROM php:cli-bullseye

ARG USERNAME=user
ARG GROUPNAME=user
ARG UID=1000
ARG GID=1000

RUN groupadd -g $GID $GROUPNAME && \
useradd -u $UID -g $GID $USERNAME

RUN apt-get update && apt-get install --assume-yes --no-install-recommends --quiet \
  unzip \
  vim \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
  
RUN pecl install xdebug && \
    docker-php-ext-enable xdebug

ENV TZ Asia/Tokyo

COPY --from=composer /usr/bin/composer /usr/bin/composer

COPY config/php.ini /usr/local/etc/php/php.ini

WORKDIR /home/$USERNAME

EXPOSE 9000

USER $USERNAME

RUN alias phpunit='./vendor/bin/phpunit'
