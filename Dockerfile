FROM daocloud.io/ubuntu:14.04
COPY ./conf /conf
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && cd /conf \
    && chmod 0777 buildImage.sh entrypoint.sh \
    && mv buildImage.sh /buildImage.sh \
    && mv entrypoint.sh /entrypoint.sh \
    && useradd -u 2048 -ms /bin/bash webadmin \
    && adduser webadmin sudo \
    && echo "webadmin ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
    && cd / \
    && /buildImage.sh
USER webadmin
EXPOSE 80
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]