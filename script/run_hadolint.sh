#!/bin/bash -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null 2>&1 && pwd)/../"
ALL_FILES=$(find $REPO_ROOT -name Dockerfile)

echo "Stopping lingering hadolint containers if any"
docker stop my_linter || true
docker rm my_linter || true

echo "Starting linter locally"
docker run -di --name my_linter hadolint/hadolint

echo "Scanning each Dockerfile"
for line in $(find "$REPO_ROOT" -name Dockerfile)
do
   printf "\nAnalyzing DOCKERFILE: %s\n" "$line"
   # Ignored hadolint hits
   #DL3003 - "Use WORKDIR to switch to a directory"
   #SC2164 - "Use cd ... || exit in case cd fails" - it should not as that's what we test when integrating the feature
   #SC1073 - "Couldn't parse this (thing). Fix to allow more checks"
   #SC1072 - "Unexpected .."
   #DL4001 - "Either use Wget or Curl but not both" - In run container we get rid of these executables anyway
   #SC2039 - "In POSIX sh, something is undefined"
   #DL3008/ DL3007 / DL3016 / DL3013 - pin versions of installations - maintenance heavy
   docker exec -i my_linter hadolint --ignore DL3003 --ignore SC2164 --ignore SC1073 --ignore SC1072 --ignore DL4001 --ignore SC2039 --ignore DL3008 --ignore DL3007 --ignore DL3016 --ignore DL3013 - < $line || printf "FAILURE: See above\n"
#   if [ $error ]
#   then 
#        printf "FAILURE: See above\n"
#        unset error
#   fi
done

echo "Stopping hadolint containers"
docker stop my_linter
docker rm my_linter
