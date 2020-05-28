#!/bin/bash -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null 2>&1 && pwd)/../"
ALL_FILES=$(find $REPO_ROOT -name Dockerfile)

echo "Stopping lingering hadolint containers if any"
docker stop my_linter || true
docker rm my_linter || true

echo "Starting linter locally"
docker run -di --name my_linter hadolint/hadolint

echo "Scanning each Dockerfile"
echo "$ALL_FILES" | while read line 
do
   printf "\nAnalyzing DOCKERFILE: $line"
   docker exec -i my_linter hadolint --ignore DL3003 --ignore SC2164 --ignore SC1073 --ignore SC1072 --ignore DL4001 --ignore SC2039 - < $line || error=true
   if [ $error ]
   then 
        printf "FAILURE: See above\n"
        unset error
   fi
done

echo "Stopping hadolint containers"
docker stop my_linter
docker rm my_linter
