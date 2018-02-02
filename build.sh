buildTools="wget"
apt-get update
apt-get install -y --no-install-recommends ${buildTools}

fileName="/opt/node.tar.gz"
wget -O ${fileName} "https://npm.taobao.org/mirrors/node/v8.9.3/node-v8.9.3-linux-x64.tar.gz"

unzipDir="/opt/nodejs"
mkdir ${unzipDir}
tar -zxf ${fileName} -C  ${unzipDir} --strip-components=1

cp ${unzipDir}/bin/node /usr/local/sbin/
ln -s ${unzipDir}/bin/npm /usr/local/sbin/npm

rm -f ${fileName}
apt-get purge -y ${buildTools}
