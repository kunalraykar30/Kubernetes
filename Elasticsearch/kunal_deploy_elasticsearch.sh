#!/bin/bash
# Author: Kunal Raykar
# Script: - kunal_deploy_elasticsearch.sh is written only to ubuntu based systems and not for any linux distro for StyleLabs.
# Usage: Run as - ./kunal_deploy_elasticsearch.sh

GREEN='\033[32m'
WC='\033[0m'

# Install the packages
printf "\nScript - kunal_deploy_elasticsearch.sh will install necessary Docker/Elasticsearch packages and bring up in the Elasticserach in Docker contianer.\nScript witll also perfrom the health check if the Elasticsearch is up and running at port -9200.\n\n"
sleep 9
printf "Updating the Ubuntu and installing the docker and docker-compose packages.\n${GREEN}"
apt-get update
apt-get install docker.io docker-compose -y

printf "\n\n${WC}Setting up the value of Virtual Memory Map count of system in /etc/sysctl.conf as vm.max_map_count=262144\n"
grep -i vm.max_map_count=262144 /etc/sysctl.conf  > /dev/null
if (( $?  == 1 ));then
        echo "vm.max_map_count=262144"  >>/etc/sysctl.conf
        printf "${GREEN}Value set properly as per ElasticSearch requirement.\n"
        sysctl -w vm.max_map_count=262144
else
        sed -i '/vm.max_map_count/c\vm.max_map_count=262144' /etc/sysctl.conf
        printf "${GREEN}Value set properly as per ElasticSearch requirement.\n"
        sysctl -w vm.max_map_count=262144
fi

# Start Docker

printf "\n${WC}Enabling the Docker Service.\n${GREEN}"
systemctl enable docker
printf "${WC}Starting the Docker Service.\n${GREEN}"
systemctl start docker
systemctl status docker  > /dev/null
if (( $? == 0 )); then
        printf "${WC}Docker has been started successfully.\n"
        printf "Docker is running with ${GREEN}`docker version |head | grep Version`${WC}\n\n"
else
        printf "Docker has not been started. Please check manually.\n"
        exit
fi

# Get docker-compose.yml from the Github

printf "Cloneing the Github Repo - ${GREEN}https://github.com/kunalraykar30/elasticsearch/\n\n"
#git clone https://github.com/kunalraykar30/elasticsearch/
wget  https://github.com/kunalraykar30/Kubernetes/blob/master/Elasticsearch/docker-compose.yml

if (( $? == 0 ));then
        printf "${WC}Running docker-compose to start up Elasticsearch.${GREEN}\n"
        docker-compose up -d

        printf "${WC}Elasticsearch continare has been started.${GREEN}\n"
        docker ps | grep elastic
        printf "${WC}\n\n"
else
        printf "Not able to reach Github. Please check if server is internet facing.\n"
fi