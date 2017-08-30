FROM daocloud.io/ubuntu:14.04
COPY ./conf /conf
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && /conf/buildImage.sh