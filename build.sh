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

# install the soap extension of php
fileName="php-7.1.8.tar.gz"
tmpDir="/tmp"
# switch to download dirctory
cd ${tmpDir}
wget -O ${fileName} "http://cn.php.net/distributions/${fileName}"
unzipDir="${tmpDir}/php"
mkdir -p ${unzipDir}
tar -xzf ${fileName} -C ${unzipDir} --strip-components=1

soapDir="${unzipDir}/ext/SOAP"

# install pgsql extension
installFn ${soapDir}

# clean up
cd ${tmpDir}
rm -f ${fileName} -rf ${unzipDir}

mv /php.ini ${phpbinDir}/../lib/
# clean up
cd ${tmpDir}
apt-get purge -y ${devDeps}
rm -rf /conf -f ${fileName} -rf ${unzipDir} /var/lib/apt/lists/*
