FROM jenkins/jenkins:lts

USER root

COPY ./sources.list /etc/apt/sources.list

RUN apt-get update && \
    apt-get install -y lsb-release build-essential libxml2-dev libssl-dev pkg-config gcc libkrb5-dev libsqlite3-dev zlib1g \
    zlib1g-dev libbz2-dev libcurl4-openssl-dev libpng-dev libjpeg-dev libonig-dev libzip-dev \
    libxpm-dev libfreetype6-dev libgmp-dev libgmp3-dev libmcrypt-dev libpspell-dev librecode-dev libreadline-dev libtidy-dev libxslt1-dev

COPY resource/php-8.1.27.tar.gz /tmp/

RUN cd /tmp && tar -zxvf php-8.1.27.tar.gz && \
    cd /tmp/php-8.1.27 && \
    ./configure --help && \
    ./configure \ 
    --prefix=/usr/local/php \ 
    --with-config-file-path=/etc \ 
    --with-fpm-user=jenkins \ 
    --with-fpm-group=jenkins \  
    --with-curl \ 
    --with-freetype-dir \ 
    --enable-gd \ 
    --with-gettext \  
    --with-iconv-dir \ 
    --with-kerberos \ 
    --with-libdir=lib64 \ 
    --with-libxml-dir \ 
    --with-mysqli \ 
    --with-openssl \ 
    --with-pcre-regex \ 
    --with-pdo-mysql \ 
    --with-pdo-sqlite \ 
    --with-pear \ 
    --with-png-dir \ 
    --with-jpeg-dir \ 
    --with-xmlrpc \ 
    --with-xsl \ 
    --with-zlib \ 
    --with-bz2 \ 
    --with-mhash \ 
    --enable-fpm \ 
    --enable-bcmath \ 
    --enable-libxml \ 
    --enable-inline-optimization \ 
    --enable-mbregex \ 
    --enable-mbstring \ 
    --enable-opcache \ 
    --enable-pcntl \ 
    --enable-shmop \ 
    --enable-soap \ 
    --enable-sockets \ 
    --enable-sysvsem \ 
    --enable-sysvshm \ 
    --enable-xml \  
    --with-zip \ 
    --enable-fpm && \
    make && make install

ENV PATH="/usr/local/php/bin:${PATH}"

RUN php -r "copy('https://install.phpcomposer.com/installer', 'composer-setup.php');" \
	&& php composer-setup.php \
	&& php -r "unlink('composer-setup.php');" \
	&& mv composer.phar /usr/local/bin/composer \
	&& composer config -g repo.packagist composer https://packagist.phpcomposer.com 

USER jenkins