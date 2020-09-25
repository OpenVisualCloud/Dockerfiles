#!/bin/bash -e
IFS=$'\n\t'

if [[ -z "$2" ]]; then
    echo "Usage: ./update-dockerhub-readme.sh <docker_prefix> <readme_filepath>"
    exit 1
fi 

DOCKER_PREFIX="$1"
README_FILEPATH="$2"
IMAGE=$(echo $README_FILEPATH | awk -F"Dockerfiles/" '{print $2}' | awk -F"/README.md" '{print $1}' | sed 's/[-.]//g'| sed 's/\//-/g' | tr 'A-Z' 'a-z')
DOCKERHUB_TOKEN=~/.dockerhub_token
REPO_URL="https://hub.docker.com/v2/repositories/${DOCKER_PREFIX}/${IMAGE}/"
IGNORE_LIST=("graphics" "owt360")
IGNORE_FLAG=-1


if [[ ! -e "${README_FILEPATH}" ]]; then
    echo "${README_FILEPATH} Error: no such file"
    exit 1
fi

for i in ${IGNORE_LIST[*]}
    do
        if [[ $IMAGE =~ $i ]]; then
            IGNORE_FLAG=0
            break
        fi
done

if [[ ${IGNORE_FLAG} == 0 ]]; then
    echo "Ignore ${README_FILEPATH}"
    exit 0
else
    echo "Updating ${README_FILEPATH}"
fi

# Acquire a token for the Docker Hub API
if [[ ! -e "${DOCKERHUB_TOKEN}" ]]; then
    echo "Dockerhub token doesn't exist, creating......"
    read -p "Input docker hub user name: " DOCKERHUB_USERNAME
    read -sp "Input docker hub password: " DOCKERHUB_PASSWORD
    LOGIN_PAYLOAD="{\"username\": \"${DOCKERHUB_USERNAME}\", \"password\": \"${DOCKERHUB_PASSWORD}\"}"
    curl -s -H "Content-Type: application/json" -X POST -d ${LOGIN_PAYLOAD} https://hub.docker.com/v2/users/login/ | jq -r .token > "${DOCKERHUB_TOKEN}" 
    echo "Dockerhub token is stored in ${DOCKERHUB_TOKEN}"
fi

# Send a PATCH request to update the description of the repository
RESPONSE_CODE=$(curl -s --write-out %{response_code} --output /dev/null -H "Authorization: JWT $(cat $DOCKERHUB_TOKEN)" -X PATCH --data-urlencode full_description@${README_FILEPATH} ${REPO_URL})

if [[ ${RESPONSE_CODE} -eq 200 ]]; then
    echo "Updated to https://hub.docker.com/repository/docker/${DOCKER_PREFIX}/${IMAGE}/"
    exit 0
else
    echo "Received dockerhub response code: $RESPONSE_CODE"
    echo "Failed to update ${README_FILEPATH}"
    exit 1
fi
