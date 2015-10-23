#
# Nginx based on Debian Latest Dockerfile
#
# https://github.com/jorelcb/nginx-debian
#
# Pull base image.
FROM debian:jessie

MAINTAINER "Jorge Corredor" <jorel.c@gmail.com>

# Install Nginx.
RUN apt-key adv --keyserver pgp.mit.edu --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62
RUN echo "deb http://nginx.org/packages/debian/ jessie nginx" >> /etc/apt/sources.list

ENV DEBIAN_FRONTEND noninteractive

# install dialog as ca-certificates prerequisite
RUN apt-get update && \
	apt-get install -y \
	dialog

# Nginx Install
RUN apt-get install -y \
    ca-certificates \
    nginx && \
    rm -rf /var/lib/apt/lists/*

# Nginx Config file
COPY config/nginx.conf /etc/nginx/nginx.conf

# ZF2 virtualhost Config file
COPY config/zf2.conf /etc/nginx/conf.d/zf2.conf

RUN rm /etc/nginx/conf.d/default.conf

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

RUN mkdir -p /srv/www
VOLUME ["/srv/www", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx", "/var/cache/nginx"]

# Expose ports.
EXPOSE 80
EXPOSE 443

# Nginx entrypoint script
COPY config/docker-nginx-entrypoint.sh /docker-nginx-entrypoint.sh
RUN chmod u=rwx /docker-nginx-entrypoint.sh
ENTRYPOINT ["/docker-nginx-entrypoint.sh"]
