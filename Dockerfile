FROM daocloud.io/kexujian/php7-fpm-nginx:ch-composer-source-931c2f9
USER root
COPY php.ini /
RUN apt-get update \
    && devDeps="wget gcc make autoconf" \
    && apt-get install -y --no-install-recommends ${devDeps} \
    && touch /etc/apt/sources.list.d/pgdg.list \
    && echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
    && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
    && apt-get update \
    && apt-get install -y --no-install-recommends libpq-dev \
    && fileName="php7.tar.gz" \
    && tmpDir="/tmp" \
    && cd ${tmpDir} \
    && wget -O ${fileName} "http://cn2.php.net/distributions/php-7.1.8.tar.gz" \
    && unzipDir="${tmpDir}/php" \
    && mkdir ${unzipDir} \
    && tar -xzf ${fileName} -C ${unzipDir} --strip-components=1 \
    && pgsqlDir="${unzipDir}/ext/pgsql" \
    && pdoPgsqlDir="${unzipDir}/ext/pdo_pgsql" \
    && phpbinDir="/usr/local/php7/bin" \
    && cp ${phpbinDir}/phpize /usr/sbin/ \
    && phpCfgDir="${phpbinDir}/php-config" \
    && cd ${pgsqlDir} \
    && phpize \
    && ./configure --with-php-config=${phpCfgDir} \
    && make \
    && make install \
    && cd ${pdoPgsqlDir} \
    && phpize \
    && ./configure --with-php-config=${phpCfgDir} \
    && make \
    && make install \
    && cd ${tmpDir} \
    && rm -f ${fileName} -rf ${unzipDir} \
    && fileName="redis-3.1.4.tgz" \
    && unzipDir="${tmpDir}/redis" \
    && mkdir ${unzipDir} \
    && wget -O ${fileName} "https://pecl.php.net/get/${fileName}" \
    && tar -xzf ${fileName} -C ${unzipDir} --strip-components=1 \
    && cd ${unzipDir} \
    && phpize \
    && ./configure --with-php-config=${phpCfgDir} \
    && make \
    && make install \
    && mv /php.ini ${phpbinDir}/../lib/ \
    && cd ${tmpDir} \
    && apt-get purge -y ${devDeps} \
    && rm -rf /conf -f ${fileName} -rf ${unzipDir} /var/lib/apt/lists/*
USER webadmin
WORKDIR /web
