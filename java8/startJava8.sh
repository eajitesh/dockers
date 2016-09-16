#!/bin/sh

if [ $# == 0 ]; then
  echo "This script expect container name argument. Example: ./installJava8.sh j8"
  exit 100
fi

docker stop $1;docker rm $1

# Build Java8 image if it does not exists
#
j8_image="java8_base"
j8_df="java8_base.df"
if [ `docker images $j8_image | wc -l` -lt 2 ]; then
  echo "Docker Image $j8_image do not exist..."
  echo "Builing docker image $j8_image"
  if [ -f $j8_df ]; then
    docker build -t $j8_image -f $j8_df .
  else
    echo "Can't find Dockerfile $j8_df in the current location"
    exit 200
  fi
fi

docker run --privileged=true -ti -dP --name $1 -v /c/Users:/mnt/Users $j8_image /bin/bash
docker exec -ti $1 /bin/bash
