#!/bin/bash -ve

nginx &

case "$1" in
    *ubuntu*)
        apt-get update && apt-get install -y -q --no-install-recommends curl;;
    *centos*)
        yum install -y -q curl;;
esac

echo "data" > test.yuv
curl -F 'data=@test.yuv' http://localhost/upload
[ "$(ls -A /var/www/upload)" ]
