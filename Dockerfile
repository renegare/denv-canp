FROM centos:centos6

# Add yum repos
RUN yum install wget -y && \
    rpm --import http://apt.sw.be/RPM-GPG-KEY.dag.txt && \
    wget http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm && \
    rpm -K rpmforge-release*.rpm && \
    rpm -i rpmforge-release*.rpm && \
    rm -f rpmforge-release*.rpm && \
    rpm --import https://fedoraproject.org/static/0608B895.txt && \
    rpm -Uvh http://download-i2.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
COPY yum.repos.d/remi.repo /etc/yum.repos.d/remi.repo

# Install OS Libs
RUN curl -sL https://rpm.nodesource.com/setup | bash - && \
    yum install -y php \
        php-imagick \
        php-gd \
        php-mysqli \
        php-pecl-apc \
        php-pecl-memcache \
        php-pecl-memcached \
        php-mbstring httpd \
        sudo which tar ntp bzip2 \
        nodejs make curl git mysql \
        python-setuptools && \
        easy_install pip && \
        pip install supervisor==3.1.2 && \
        curl -sS https://getcomposer.org/installer | php  && \
        mv composer.phar /usr/local/bin/composer && \
        chkconfig ntpd on

RUN cat /etc/centos-release >> /tmp/installed.txt && \
    echo $(apachectl -v | grep Apache -m 1) >> /tmp/installed.txt && \
    echo $(php -v | grep -m 1 PHP) >> /tmp/installed.txt && \
    echo $(composer --version) >> /tmp/installed.txt && \
    echo $(php -m | tr '\n+' ', ') >> /tmp/installed.txt && \
    echo "NPM $(npm -v)" >> /tmp/installed.txt && \
    echo "NodeJS $(node -v)" >> /tmp/installed.txt && \
    echo "Supervisord $(supervisord -v)" >> /tmp/installed.txt

CMD ["/bin/bash"]
