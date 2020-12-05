#!/usr/bin/env bash

dahuavtomqtt=$(cd ./DahuaVTO2MQTT && pwd)
hak5c2=$(cd ./hak5c2 && pwd)
letslexicon=$(cd ./letslexicon && pwd)
uniums=$(cd ./unimus && pwd)

echo "Building for ${dahuavtomqtt} uploading to Docker Hub as ${DOCKER_USER}"

docker run --rm --privileged \
   -v ${dahuavtomqtt}:/data \
   homeassistant/amd64-builder --docker-user "${DOCKER_USER}" --docker-password "${DOCKER_PASSWORD}" \
   --all -t /data

echo "Building for ${hak5c2} uploading to Docker Hub as ${DOCKER_USER}"

docker run --rm --privileged \
    -v ${hak5c2}:/data \
    homeassistant/amd64-builder --docker-user "${DOCKER_USER}" --docker-password "${DOCKER_PASSWORD}" \
    --all -t /data

echo "Building for ${letslexicon} uploading to Docker Hub as ${DOCKER_USER}"

docker run --rm --privileged \
   -v ${letslexicon}:/data \
   homeassistant/amd64-builder --docker-user "${DOCKER_USER}" --docker-password "${DOCKER_PASSWORD}" \
   --all -t /data

echo "Building for ${uniums} uploading to Docker Hub as ${DOCKER_USER}"

docker run --rm --privileged \
   -v ${uniums}:/data \
   homeassistant/amd64-builder --docker-user "${DOCKER_USER}" --docker-password "${DOCKER_PASSWORD}" \
   --all -t /data
