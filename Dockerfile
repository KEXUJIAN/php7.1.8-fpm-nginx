FROM daocloud.io/kexujian/php7-fpm-nginx:soap-37011e9
USER root
RUN rm -f build.sh
COPY . /
RUN chmod 0777 /build.sh \
    && sync \
    && /build.sh \
    && rm -f /build.sh
USER webadmin
