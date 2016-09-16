set -xv

#!/bin/sh

if [ $# == 0 ]; then
  echo "This script expecs version and container name as argument. Example: ./startJava.sh -v 7 java"
  exit 100
fi

if [ $1 == '-v' ]; then
  expr $2 + 1 2> /dev/null
  if [ $? = 0 ]; then
    echo "Version: $2"
  else
    echo "Version can only be numeric. Value supported are 7, 8"
    exit 100
  fi
else
  echo "This script expecs version and container name as argument. Example: ./startJava.sh -v 7 java"
  exit 100
fi

docker stop $3;docker rm $3

java_image=""
java_df=""
if [ $2 == 8 ]; then
  java_image="java8_base"
  java_df="java8.df"
else
  if [ $2 == 7 ]; then
    java_image="java7_base"
    java_df="java7.df"
  else
    echo "This script only supports Java containers for version 7 or 8. Please try again!"
    exit 100 
  fi
fi

# Build Java image if it does not exists
#
if [ `docker images $java_image | wc -l` -lt 2 ]; then
  echo "Docker Image $java_image do not exist..."
  echo "Builing docker image $java_image"
  if [ -f $java_df ]; then
    docker build -t $java_image -f $java_df .
  else
    echo "Can't find Dockerfile $java_df in the current location"
    exit 200
  fi
fi

docker run --privileged=true -ti -dP --name $3 -v /c/Users:/mnt/Users $java_image /bin/bash
docker exec -ti $3 /bin/bash
