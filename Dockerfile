FROM daocloud.io/kexujian/php7-fpm-nginx:master-fce5ebc
RUN composer config -g repo.packagist composer https://packagist.phpcomposer.com
