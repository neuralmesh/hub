#!/bin/bash

# Usage check
if [ "$#" -ne 4 ]; then
    echo "Usage: $0 <git-repo-url> <image-name> <port-extern> <port-intern>"
    exit 1
fi

# Assigning arguments to variables
REPO_URL=$1
IMAGE_NAME=$2
PORT_EXTERN=$3
PORT_INTERN=$4

# Docker build
docker build --build-arg REPO_URL=$REPO_URL -t $IMAGE_NAME .

# Stop and remove any existing container using the port
CONTAINER_USING_PORT=$(docker ps --filter "publish=$PORT_EXTERN" -q)
if [ ! -z "$CONTAINER_USING_PORT" ]; then
    docker stop $CONTAINER_USING_PORT
    docker rm $CONTAINER_USING_PORT
fi

# Run the new container
CONTAINER_ID=$(docker run -d -p $PORT_EXTERN:$PORT_INTERN $IMAGE_NAME)

# Wait for the container to start running
while [ "$(docker inspect --format='{{.State.Running}}' $CONTAINER_ID)" != "true" ]; do
    sleep 1
done

# Executing shell in the container
docker exec -it $CONTAINER_ID /bin/sh

