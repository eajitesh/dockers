#!/bin/sh

if [ $# == 0 ]; then
  echo "This script expect container name argument. Example: ./installTS.sh jsdev"
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
js_image="javascript"
js_df="javascript.df"
if [ `docker images $js_image | wc -l` -lt 2 ]; then
  echo "Docker Image $js_image do not exist..."
  echo "Builing docker image $js_image"
  if [ -f $js_df ]; then
    docker build -t $js_image -f $js_df .
  else
    echo "Can't find Dockerfile $js_df in the current location"
    exit 200
  fi
fi

docker run --privileged=true -ti -dP --name $1 -v /c/Users:/mnt/Users $js_image /bin/bash
docker exec -ti $1 bash
