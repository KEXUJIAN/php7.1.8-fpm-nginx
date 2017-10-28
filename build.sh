#!/bin/sh

installFn()
{
    cd $1
    phpize
    ./configure --with-php-config=php-config
    make && make install
}

# get build tools
apt-get update
devDeps="wget gcc make autoconf"
apt-get install -y --no-install-recommends ${devDeps}

# replace the apt package source of pgsql
touch /etc/apt/sources.list.d/pgdg.list
echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" > /etc/apt/sources.list.d/pgdg.list
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
apt-get update

# install the pgsql, pdo_pgsql, redis extension of php
apt-get install -y --no-install-recommends libpq-dev
fileName="php-7.1.8.tar.gz"
tmpDir="/tmp"
# switch to download dirctory
cd ${tmpDir}
wget -O ${fileName} "http://cn2.php.net/distributions/${fileName}"
unzipDir="${tmpDir}/php"
mkdir -p ${unzipDir}
tar -xzf ${fileName} -C ${unzipDir} --strip-components=1
pgsqlDir="${unzipDir}/ext/pgsql"
pdoPgsqlDir="${unzipDir}/ext/pdo_pgsql"
phpbinDir="/usr/local/php7/bin"
# export phpize and php-config to system path
cp ${phpbinDir}/phpize ${phpbinDir}/php-config /usr/sbin/
# install pgsql extension
installFn ${pgsqlDir}
# install pdo_pgsql
installFn ${pdoPgsqlDir}

# clean up
cd ${tmpDir}
rm -f ${fileName} -rf ${unzipDir}

# prepare to install redis extension
fileName="redis-3.1.4.tgz"
unzipDir="${tmpDir}/redis"
mkdir -p ${unzipDir}
wget -O ${fileName} "https://pecl.php.net/get/${fileName}"
tar -xzf ${fileName} -C ${unzipDir} --strip-components=1
# install
installFn ${unzipDir}

mv /php.ini ${phpbinDir}/../lib/
# clean up
cd ${tmpDir}
apt-get purge -y ${devDeps}
rm -rf /conf -f ${fileName} -rf ${unzipDir} /var/lib/apt/lists/*
