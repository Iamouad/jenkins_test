#!/bin/bash

set -e
echo $1 $2
cp $1 /root/jenkins_test/
docker build /root/jenkins_test -t nginx-custom:$2
#start test container on port 8082
echo ------------- Starting Test container --------------------
docker run -ti --rm -d -p 8082:80 --name web-server-test nginx-custom:$2
#Readiness test
i=0
while [[ $(docker inspect -f json web-server-test |jq -r .[0].State.Status) != running ]]; do
	sleep 1;
	i=$(expr $i + 1)
	if [[ "$i" -gt "5"  ]]; then 
	   docker rm -f web-server-test
	   echo "Timeout!!! Container not running after waiting $is "
	   exit 1
	fi
done
#Test container test
echo ------------- Testing Test container --------------------
curl localhost:8082
#Remove test container
echo ------------- Removing Test container --------------------
docker rm -f web-server-test
#Upgrade main container
echo ------------- Upgrading App container --------------------
docker rm -f web-server
docker run -ti --rm -d -p 8081:80 --name web-server nginx-custom:$2
curl localhost:8081
exit 0
