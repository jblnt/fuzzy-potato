FROM nextcloud:apache

RUN set -ex; \
    \
    apt-get update; \
    apt-get install -y --no-install-recommends ffmpeg libmagickcore-6.q16-6-extra procps smbclient; \
    \
    rm -rf /var/lib/apt/lists/*

RUN set -ex; \
    \
    apt-get update; \
    apt-get install -y --no-install-recommends libbz2-dev libc-client-dev libkrb5-dev libsmbclient-dev; \
    \
    docker-php-ext-configure imap --with-kerberos --with-imap-ssl; \
    docker-php-ext-install bz2 imap; \
    pecl install smbclient; \
    docker-php-ext-enable smbclient; \
    \
    rm -rf /var/lib/apt/lists/*

RUN a2enmod ssl; \
    a2enmod rewrite; \
    a2enmod headers 

COPY ssl-nextcloud.conf /etc/apache2/sites-available/

RUN a2ensite ssl-nextcloud && a2dissite 000-default

RUN mkdir -p /etc/apache2/certs

RUN mkdir -p /srv/nextcloud/data; \
    chown www-data /srv/nextcloud/data

