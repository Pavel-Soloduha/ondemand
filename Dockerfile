FROM rockylinux/rockylinux:8.5

ARG VERSION=latest
ARG CONCURRENCY=4
ENV PYTHON=/usr/libexec/platform-python

# setup the ondemand repositories
RUN dnf -y install https://yum.osc.edu/ondemand/2.0/ondemand-release-web-2.0-1.noarch.rpm

# install all the dependencies
RUN dnf -y update && \
    dnf install -y dnf-utils && \
    dnf install 'dnf-command(config-manager)' -y && \
    dnf config-manager --set-enabled powertools && \
    dnf -y module enable nodejs:12 ruby:2.7 && \
    dnf install -y \
        vi \
        vim \
        nano \
        file \
        lsof \
        sudo \
        mod_ssl \
        ondemand \
        ondemand-dex && \
    dnf clean all && rm -rf /var/cache/dnf/*

COPY docker/launch-web      /opt/ood/start-web
COPY docker/launch-ood      /opt/ood/launch
# set servername
COPY docker/ood_portal.yml /etc/ood/config/ood_portal.yml

RUN openssl req -newkey rsa:4096 -x509 -sha256 -days 3650 -nodes -batch \
  -out /etc/pki/tls/certs/localhost.crt \
  -keyout /etc/pki/tls/private/localhost.key

RUN groupadd ood
RUN useradd -d /home/ood -g ood -k /etc/skel -m ood

EXPOSE 80
EXPOSE 3035
EXPOSE 5556
EXPOSE 8080

ENTRYPOINT [ "/opt/ood/launch" ]
