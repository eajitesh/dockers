#!/bin/sh

if [ $# == 0 ]; then
  echo "This script expect container name argument. Example: ./installTS.sh ts1"
  exit 100
fi

docker stop $1;docker rm $1

# Build NodeJS image if it does not exists
#
nb_image="nodejs_base"
nb_df="nodejs_base.df"
if [ `docker images $nb_image | wc -l` -lt 2 ]; then
  echo "Docker Image $nb_image do not exist..."
  echo "Builing docker image $nb_image"
  if [ -f $nb_df ]; then
    docker build -t $nb_image -f $nb_df .
  else
    echo "Can't find Dockerfile $nb_df in the current location"
    exit 200
  fi
fi

# Build Typescript image if it does not exists
#
ts_image="typescript"
ts_df="typescript.df"
if [ `docker images $ts_image | wc -l` -lt 2 ]; then
  echo "Docker Image $ts_image do not exist..."
  echo "Builing docker image $ts_image"
  if [ -f $ts_df ]; then
    docker build -t $ts_image -f $ts_df .
  else
    echo "Can't find Dockerfile $ts_df in the current location"
    exit 200
  fi
fi

docker run --privileged=true -ti -dP --name $1 -v /c/Users:/mnt/Users $ts_image /bin/bash
