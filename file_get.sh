#!/bin/bash

FILE_GET_SRC=$1
FILE_GET_DST=$2

docker container create --name amat-osmtools-dummy -v amat-osmtools-data:/amat-osmtools-data amat-osmtools:2.2.0
docker cp amat-osmtools-dummy:/amat-osmtools-data/$FILE_GET_SRC $FILE_GET_DST
docker rm amat-osmtools-dummy
