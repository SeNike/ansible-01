#!/bin/bash
CONTAINER_NAME="ubuntu"

# Запуск контейнера Ubuntu
docker run -d --name $CONTAINER_NAME ubuntu:latest sleep infinity

# Установка обновлений и Python в контейнере
docker exec -it $CONTAINER_NAME bash -c "
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y python3"

# Запуск остальных контейнеров 
docker run -d --name fedora pycontribs/fedora sleep infinity
docker run -d --name centos7 centos:7 sleep infinity

# Запуск ansible
ansible-playbook site.yml -i inventory/prod.yml --ask-vault-password

# Остановка и удаление контейнеров
docker stop fedora ubuntu centos7
docker rm fedora ubuntu centos7