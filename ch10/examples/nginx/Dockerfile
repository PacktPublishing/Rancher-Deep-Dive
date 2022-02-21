FROM nginx:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -yq --no-install-recommends \
    apt-utils \
    curl \
    wget \
    openssl \
    bash \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY status.conf /etc/nginx/conf.d/

