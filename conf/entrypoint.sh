#!/bin/sh
startFn()
{
    ps -ef|grep $1|grep -v grep > /dev/null
    if [ $? != 0 ];then
        sudo $1
    fi
}

startFn nginx
startFn php-fpm

exec "$@"