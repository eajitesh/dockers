#!/bin/sh

if [ $# == 0 ]; then
  echo "This script expect container name argument. Example: ./installNode.sh node1"
  exit 100
fi

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

docker run -ti -dP --name $1 -v /c/Users:/mnt/Users $nb_image /bin/bash
