#
# Nginx based on Debian Latest Dockerfile
#
# https://github.com/jorelcb/nginx-debian
#

# Pull base image.
FROM debian:latest

MAINTAINER Jorge Corredor "jorel.c@gmail.com"

# Install Nginx.

RUN apt-key adv --keyserver pgp.mit.edu --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62
RUN echo "deb http://nginx.org/packages/debian/ jessie nginx" >> /etc/apt/sources.list

ENV NGINX_VERSION 1.8.0-1~jessie

# install dialog as ca-certificates prerequisite
RUN apt-get update && \
	apt-get install -y \
	dialog

# Nginx Install
RUN apt-get install -y \
    ca-certificates \
    nginx=${NGINX_VERSION} && \
    rm -rf /var/lib/apt/lists/* && \
    echo "\ndaemon off;" >> /etc/nginx/nginx.conf

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx", "/var/cache/nginx"]

# Define working directory.
WORKDIR /etc/nginx

# Expose ports.
EXPOSE 80
EXPOSE 443

# Define default command.
CMD ["nginx"]
