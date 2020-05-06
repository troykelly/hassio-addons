#!/usr/bin/env bash

uniums=$(cd ./unimus && pwd)
dahuavtomqtt=$(cd ./DahuaVTO2MQTT && pwd)

echo "Building for ${dahuavtomqtt} uploading to Docker Hub as ${DOCKER_USER}"

docker run --rm --privileged \
    -v ${dahuavtomqtt}:/data \
    homeassistant/amd64-builder --docker-user "${DOCKER_USER}" --docker-password "${DOCKER_PASSWORD}" \
    --all -t /data

echo "Building for ${uniums} uploading to Docker Hub as ${DOCKER_USER}"

docker run --rm --privileged \
    -v ${uniums}:/data \
    homeassistant/amd64-builder --docker-user "${DOCKER_USER}" --docker-password "${DOCKER_PASSWORD}" \
    --all -t /data