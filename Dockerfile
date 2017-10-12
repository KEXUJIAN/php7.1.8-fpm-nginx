FROM daocloud.io/kexujian/php7-fpm-nginx:latest
RUN composer config -g repo.packagist composer https://packagist.phpcomposer.com
