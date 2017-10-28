FROM daocloud.io/kexujian/php7-fpm-nginx:ch-composer-source-931c2f9
USER root
RUN rm -f buildImage.sh
COPY . /
RUN build.sh \
    && chmod 0777 /web
USER webadmin
WORKDIR /web
