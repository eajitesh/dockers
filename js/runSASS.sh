#!/bin/sh

if [ $# == 0 ]; then
  echo "This script expect container name argument. Example: ./runSASS.sh sass"
  exit 100
fi

docker stop $1;docker rm $1

# Build NodeJS image if it does not exists
#
rb_image="ruby"
rb_df="ruby.df"
if [ `docker images $rb_image | wc -l` -lt 2 ]; then
  echo "Docker Image $rb_image do not exist..."
  echo "Builing docker image $rb_image"
  if [ -f $rb_df ]; then
    docker build -t $rb_image -f $rb_df .
  else
    echo "Can't find Dockerfile $rb_df in the current location"
    exit 200
  fi
fi

docker run -ti -dP --name $1 -v /c/Users:/mnt/Users $rb_image /bin/bash
