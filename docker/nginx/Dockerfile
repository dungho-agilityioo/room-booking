FROM nginx

ARG DOMAIN

# Create directory for placing letsencrypt configs and cert files
RUN mkdir -p /etc/letsencrypt/configs
RUN mkdir -p /etc/letsencrypt/live/${DOMAIN}
RUN mkdir -p /var/www/letsencrypt

# Add jessie-backports repository to source list
RUN echo 'deb http://ftp.debian.org/debian jessie-backports main' >> /etc/apt/sources.list.d/backports.list

RUN apt-get update && \
    apt-get install -y certbot -t jessie-backports && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    openssl req -x509 -nodes -days 365 -newkey rsa:4096 \
        -keyout /etc/letsencrypt/live/${DOMAIN}/privkey.pem \
        -out /etc/letsencrypt/live/${DOMAIN}/fullchain.pem \
        -subj /CN=${DOMAIN}

ADD api.conf.tpl /etc/nginx/conf.d/api.conf.tpl
#ADD letsencrypt.conf /etc/letsencrypt/configs/${DOMAIN}.conf

RUN envsubst '$${DOMAIN}' < /etc/nginx/conf.d/api.conf.tpl > /etc/nginx/conf.d/default.conf && \
    unlink /etc/nginx/conf.d/api.conf.tpl
