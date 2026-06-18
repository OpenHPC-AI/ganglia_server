FROM rockylinux:9.6

LABEL maintainer="CDAC HPC Team"

ENV container=docker

RUN dnf -y update && \
    dnf -y install dnf-plugins-core epel-release && \
    dnf config-manager --set-enabled crb 

RUN dnf -y install \
        httpd \
        php \
        php-cli \
        php-common \
        php-gd \
        php-mbstring \
        php-fpm \
        rrdtool \
        rrdtool-perl \
        gettext \
        sudo \
        procps-ng \
        initscripts \
        wget \
        tar \
        gzip \
        supervisor && \
    dnf clean all

#
# Install Ganglia from source RPM or custom repository
#
COPY rpms/ /tmp/rpms/

RUN dnf -y localinstall /tmp/rpms/*.rpm || true

COPY ./httpd_initscripts /etc/init.d/httpd
COPY ./etc_ganglia /ganglia_conf
COPY ./supervisord.conf /etc/supervisord.conf
COPY ./entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh && \
    chmod +x /etc/init.d/httpd

RUN mkdir -p \
    /run/php-fpm \
    /var/lib/ganglia/rrds \
    /var/log/ganglia

EXPOSE 8649
EXPOSE 8651
EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
