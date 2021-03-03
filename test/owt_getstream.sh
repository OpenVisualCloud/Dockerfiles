#!/bin/bash -ve
case "$1" in
    *ubuntu*)
        apt-get update && apt-get install -y -q --no-install-recommends curl;;
    *centos*)
        yum install -y -q curl;;
esac

/home/launch.sh

#response=$(curl -sb -H "Accept: application/json" http://localhost:3001/rooms | awk '{split($0,a,","); print a[1]}' | awk '{split($0,a,":"); print a[2]}' | tr -d \")
response=$(curl -sb -H "Accept: application/json" http://localhost:3001/rooms | awk -F "," '{print $NF}' | awk '{split($0,a,"\""); print a[4]}')
echo $response
recording=$(curl -H "Content-Type: application/json" -X POST -d '{"media":{"audio":{"from":"${response}-common"},"video":{"from":"${response}-common"}}}' http://localhost:3001/rooms/${response}/recordings)
echo $recording
result=$(curl -sb -H http://localhost:3001/rooms/${response}/streams/${response}-common)
echo $result
if [[ $result == *"video"* ]]; then
  echo "Get mix stream succeeded!"
else
  cd /home/owt/logs
  grep error . -ir
  grep warn . -ir
  echo "Get stream failed!"
  exit 1
fi
