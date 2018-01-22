FROM daocloud.io/kexujian/php7-fpm-nginx:redis-pgsql
USER root
RUN rm -f build.sh
COPY . /
RUN mkdir -p /web \
    && chown -R webadmin /web \
    && chmod 0777 /web /build.sh \
    && sync \
    && /build.sh
RUN locale-gen zh_CN.UTF-8 &&\
  DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales
RUN locale-gen zh_CN.UTF-8
ENV LANG zh_CN.UTF-8
ENV LANGUAGE zh_CN:zh
ENV LC_ALL zh_CN.UTF-8
USER webadmin
EXPOSE 9000
EXPOSE 3306
