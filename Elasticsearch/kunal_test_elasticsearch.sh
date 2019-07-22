#!/bin/bash
# Author: Kunal Raykar
# Script: - kunal_test_elasticsearch.sh is written only to ubuntu based systems and not for any linux distro for StyleLabs.
# Usage: Run as - ./kunal_test_elasticsearch.sh after scrip - kunal_deploy_elasticsearch.sh is executed.

GREEN='\033[32m'
WC='\033[0m'
printf "NOTE: You might need to RE-RUN sript again as sometimes it takes time for Elasticsearch to come up."

printf "\n${WC}Peforming health check of the Elasticsearch.\nChecking if the default port - 9200 of Elasticsearch is running.\n${GREEN}"
netstat -tlnp |grep -i 9200
sleep 5

if(( $? == 0 ));then

        printf "Port 9200 is listening.\n\n${WC}Checking the status of the Elasticsearch.\nWe will fire command - curl -XGET 'localhost:9200/_cat/health?v&pretty' fromconatiner in oder to check if Elasticserach is running.\n\n${GREEN}"
        sleep 5
        DOCKERID=`docker ps | awk '{print $1}' | grep -v CONTAINER`
        CMD="sh -c \"curl -XGET 'localhost:9200/_cat/health?v&pretty'\""
        DOCKERCMD="docker exec -it"
        echo $DOCKERCMD $DOCKERID $CMD > docker.txt
        chmod +x docker.txt
./docker.txt
rm docker.txt
        printf "${WC}Port is responding and Elasticsearch is healthy.\n\n"
else
        printf "Elasticsearch is not running.\n"
fi
