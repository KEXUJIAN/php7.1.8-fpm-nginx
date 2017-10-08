#!/bin/sh
confDir='/conf'
fileName='php7.tar.gz'
unzipDir='/usr/src/php7'
installDir='/usr/local/php7'
mv ${confDir}/sources.list /etc/apt/
mv ${confDir}/composer.phar /usr/local/bin/composer

chown webadmin /usr/local/bin/composer
chmod 0555 /usr/local/bin/composer
buildTools='gcc make wget g++'
buildDps='bison re2c libc6-dev nginx libxml2-dev zlib1g-dev libjpeg-dev libpng-dev libfreetype6-dev libssl-dev pkg-config libmcrypt-dev libcurl4-openssl-dev libicu-dev'
apt-get update
apt-get install -y ${buildDps} ${buildTools}
# configure nginx
rm -f /etc/nginx/sites-enabled/default
mv ${confDir}/nginx.conf /etc/nginx/
mv ${confDir}/default.conf /etc/nginx/conf.d/default.conf
# download php
wget -O ${fileName} "http://cn2.php.net/distributions/php-7.1.8.tar.gz"
mkdir -p ${unzipDir} ${installDir}
echo 'waiting for extracting...'
tar -xzf ${fileName} -C ${unzipDir} --strip-components=1
# compile and install php
cd ${unzipDir}
./configure --prefix=${installDir} \
--with-openssl --with-libxml-dir --with-mcrypt --with-curl \
--with-zlib-dir --with-jpeg-dir --with-png-dir --with-freetype-dir --with-gd \
--enable-zip --enable-mbstring --enable-mysqlnd --enable-intl \
--with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd \
--without-pdo-sqlite --without-sqlite3 \
--enable-opcache --enable-fpm
make -C ${unzipDir}
make -C ${unzipDir} install
echo 'Installation of php has finished.'
cd /
phpIni=${confDir}/php.ini
# configuration of php and php-fpm
mv ${phpIni} ${phpIni}-production ${phpIni}-development ${installDir}/lib/
mv ${confDir}/php-fpm.conf ${installDir}/etc/
mv ${confDir}/www.conf ${installDir}/etc/php-fpm.d/
# copy the executable files to path so we can use them anywhere
cp ${installDir}/bin/php ${installDir}/sbin/php-fpm /usr/sbin/
cp ${installDir}/sbin/php-fpm /etc/init.d/
chmod 0644 ${installDir}/lib/php.ini* ${installDir}/etc/php-fpm.conf ${installDir}/etc/php-fpm.d/*
echo 'cleaning up...'
apt-get clean
apt-get purge -y ${buildTools}
rm -f ${fileName} -rf ${unzipDir} /var/lib/apt/lists/*
exit 0
