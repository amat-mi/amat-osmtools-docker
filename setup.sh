#!/bin/bash

# Build builder container image
# Create a stopped instance out of it
# Copy artifacts from container instance to local context of runtime container
# Remove instance of builder container
# Remove image of builder container
docker build -t amat-osmtools/builder:2.2.0 builder
docker container create --name amat-osmtools-builder amat-osmtools/builder:2.2.0
docker cp amat-osmtools-builder:/usr/local/bin/osm2pgrouting container/osm2pgrouting
docker cp amat-osmtools-builder:/amat-osmtools/script/osmupdate/osmconvert container/osmconvert
docker cp amat-osmtools-builder:/amat-osmtools/script/osmupdate/osmupdate container/osmupdate
docker rm amat-osmtools-builder
docker image rm amat-osmtools/builder:2.2.0

# Build runtime container
docker build -t amat-osmtools:2.2.0 container

# Remove artifacts from local context of runtime container
rm container/osm2pgrouting

# Create volume for persistent data inside container (NOT shared with host machine)
docker volume create amat-osmtools-data
