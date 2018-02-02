FROM daocloud.io/kexujian/php7-fpm-nginx:soap-0bfd0eb
USER root
RUN rm -f build.sh
COPY . /
RUN cp /php.ini /usr/local/php7/lib/php.ini
USER webadmin
