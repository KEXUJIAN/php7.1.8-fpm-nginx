#!/bin/sh
confDir='/conf'
fileName='php7.tar.gz'
unzipDir='/usr/src/php7'
installDir='/usr/local/php7'
mv ${confDir}/sources.list /etc/apt/
mv ${confDir}/composer.phar /usr/local/bin/composer
buildTools='gcc make wget'
buildDps='bison re2c libc6-dev nginx libxml2-dev zlib1g-dev libjpeg-dev libpng-dev libfreetype6-dev libssl-dev pkg-config libmcrypt-dev libcurl4-openssl-dev'
apt-get update
apt-get install -y ${buildDps} ${buildTools}
wget -O ${fileName} "http://cn2.php.net/distributions/php-7.1.8.tar.gz"
mkdir -p ${unzipDir} ${installDir}
echo 'waiting for extracting...'
tar -xzf ${fileName} -C ${unzipDir} --strip-components=1
cd ${unzipDir}
./configure --prefix=${installDir} \
--with-openssl --with-libxml-dir --with-mcrypt --with-curl \
--with-zlib-dir --with-jpeg-dir --with-png-dir --with-freetype-dir --with-gd \
--enable-zip --enable-mbstring --enable-mysqlnd \
--with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd \
--without-pdo-sqlite --without-sqlite3 \
--enable-opcache --enable-fpm
make -C ${unzipDir}
make -C ${unzipDir} install
echo 'Installation of php has finished.'
cd /
phpIni=${confDir}/php.ini
mv ${phpIni} ${phpIni}-production ${phpIni}-development ${installDir}/lib/
mv ${confDir}/php-fpm.conf ${installDir}/etc/
mv ${confDir}/www.conf ${installDir}/etc/php-fpm.d/
cp ${installDir}/bin/php ${installDir}/sbin/php-fpm /usr/sbin/
cp ${installDir}/sbin/php-fpm /etc/init.d/
chmod 0644 ${installDir}/lib/php.ini* ${installDir}/etc/php-fpm.conf ${installDir}/etc/php-fpm.d/*
echo 'cleaning up...'
apt-get clean
apt-get purge -y ${buildTools}
rm -f ${fileName} -rf ${unzipDir} /var/lib/apt/lists/*
exit 0
