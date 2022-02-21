FROM httpd:2.4

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -yq --no-install-recommends \
    apt-utils \
    curl \
    wget \
    openssl \
    apache2 \
    bash \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY server-status.conf /etc/apache2/sites-available/
RUN a2ensite server-status.conf
RUN a2enmod status

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
