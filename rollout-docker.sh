#!/bin/bash

set -e
echo $1 $2
cp $1 /root/jenkins_test/
docker build /root/jenkins_test -t nginx-custom:$2
#start test container on port 8082
docker run -ti --rm -d -p 8082:80 --name web-server-test nginx-custom:$2
#Readiness test
while [[ $(docker inspect -f json web-server-test |jq -r .[0].State.Status) != running ]]; do
	sleep 1;
done
#Test container test
curl localhost:8082
#Remove test container
docker rm -f web-server-test
#Update main container
docker rm -f web-server
docker run -ti --rm -d -p 8081:80 --name web-server nginx-custom:$2
while [[ $(docker inspect -f json web-server |jq -r .[0].State.Status) != running ]]; do
        sleep 1;
done
curl localhost:8081
exit 0
