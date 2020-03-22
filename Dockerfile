FROM debian:buster
MAINTAINER Elrondo46 <dd@dd.fr>

VOLUME ["/var/www"]

RUN apt-get update && \ 
    apt-get install -y ca-certificates \
    apt-transport-https gnupg2 \
    wget

RUN wget -q https://packages.sury.org/php/apt.gpg -O- | apt-key add - && \
echo "deb https://packages.sury.org/php/ buster main" | tee /etc/apt/sources.list.d/php.list

RUN apt-get update && \
    apt-get install -y \
      locales \
      apache2 \
      php5.6 \
      php5.6-cli \
      php5.6-common \
      php5.6-mbstring \
      php5.6-mysql \
      php5.6-xml \
      php5.6-json \
      php5.6-soap \
      php5.6-zip \
      php5.6-bcmath \
      php5.6-bz2 \
      php5.6-dba \
      php5.6-gd \
      php5.6-gmp \
      php5.6-interbase \
      php5.6-intl \
      php5.6-mcrypt \
      php5.6-opcache \
      php5.6-readline \
      php5.6-sybase \
      php5.6-curl \
      python-certbot-apache \
      vim \
      bash \
      libapache2-mod-php5.6

COPY apache_default /etc/apache2/sites-available/000-default.conf
COPY run /usr/local/bin/run
RUN chmod +x /usr/local/bin/run
RUN a2enmod rewrite
RUN a2enmod php5.6

EXPOSE 80
EXPOSE 443
CMD ["/usr/local/bin/run"]
