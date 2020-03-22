debian10-apache-php56
===================================

A Docker image based on Debian Buster, serving PHP 5.6 running as Apache Module. Useful for Web developers in need for a fixed PHP version. In addition, the `error_reporting` setting in php.ini is configurable per container via environment variable.

Tags
-----

* latest: Debian 10 (Buster), Apache 2.x, PHP 5.6.x with support for setting `error_reporting`

Usage
------

```
$ docker run -d -P tuxnvape/debian10-apache-php56
```

With all the options:

```bash
$ docker run -d -p 80:80 \
    -p 443:443
    -v /home/user/webroot:/var/www \
    -e PHP_ERROR_REPORTING='E_ALL & ~E_STRICT' \
    tuxnvape/debian10-apache-php56
```

* `-v [local path]:/var/www` maps the container's webroot to a local path
* `-p [local port]:80` maps a local port to the container's HTTP port 80
* `-p [local port]:443` maps a local port to the container's HTTP port 443
* `-e PHP_ERROR_REPORTING=[php error_reporting settings]` sets the value of `error_reporting` in the php.ini files.

### Access apache logs

Apache is configured to log both access and error log to STDOUT. So you can simply use `docker logs` to get the log output:

`docker logs -f container-id`

Configurations
----------------

* Apache: .htaccess-Enabled in webroot (mod_rewrite with AllowOverride all)
* php.ini:
  * display_errors = On
  * error_reporting = E_ALL (default, overridable per env variable)
  * certbot is preinstalled you can manage it
  
Mariadb integration
----------------

You can use there environnement variables. Please take attention to the docker composer configuration below 

```yaml
version: '3'

volumes:
  volapache:
  certbot:
  db:
  apache2config:

services:

  mariadb:
    image: mariadb:latest
    restart: always
    volumes:
      - db:/var/lib/mysql
    environment:
        - "MYSQL_DATABASE=example"
        - "MYSQL_USER=example"
        - "MYSQL_PASSWORD=pass"
        - "MYSQL_RANDOM_ROOT_PASSWORD=yes"

  b4f:
    image: tuxnvape/debian10-apache-php56:latest
    restart: always
    depends_on:
        - mariadb
    ports:
        - "80:80"
        - "443:443"
    environment:
        - "SITE_DB_HOST=mariadb"
        - "SITE_DB_NAME=example"
        - "SITE_DB_USER=example"
        - "SITE_DB_PASSWORD=pass"
    volumes:
        - volapache:/var/www
        - apache2config:/etc/apache2
        - certbot:/etc/letsencrypt
```
