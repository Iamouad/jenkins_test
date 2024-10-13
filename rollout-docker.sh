#!/bin/bash

set -e
#Retrieve the current deployment image version
current_deployed_tag=$(docker ps -f name=web-server --format json | jq -r .Image)
cp $1 /root/jenkins_test/

echo ------------- Building Docker --------------------
docker build --no-cache /root/jenkins_test -t nginx-custom:$2

#start test container on port 8082
echo ------------- Starting Test container --------------------
docker rm -f web-server-test || echo "Cleanining up test environement"
docker run -ti --rm -d -p 8082:80 --name web-server-test nginx-custom:$2

#Readiness test
i=0
while [[ $(docker inspect -f json web-server-test |jq -r .[0].State.Status) != running ]]; do
	sleep 1;
	i=$(expr $i + 1)
	if [[ "$i" -gt "5"  ]]; then 
	   docker rm -f web-server-test
	   echo "Timeout!!! Container not running after waiting $i (s)"
	   exit 1
	fi
done

#Test the output of the test container
echo ------------- Testing Test container --------------------
curl localhost:8082

#Cleanup test environement
echo ------------- Removing Test container --------------------
docker rm -f web-server-test

#Upgrade main container
echo ------------- Upgrading App container --------------------
docker rm -f web-server
docker run -ti --rm -d -p 8081:80 --name web-server nginx-custom:$2
i=0
while [[ $(docker inspect -f json web-server |jq -r .[0].State.Status) != running ]]; do
        sleep 1;
        i=$(expr $i + 1)
        if [[ "$i" -gt "5"  ]]; then
           docker rm -f web-server
	   echo "Timeout!!! Container not running after waiting $i (s)"
	   #Rollback in case of failure
	   echo "------------------- Rolling back deployment -------------------"
           docker run -ti --rm -d -p 8081:80 --name web-server $current_deployed_tag
           exit 1
        fi
done

curl localhost:8081
exit 0
