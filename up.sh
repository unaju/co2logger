#!/bin/bash

sudo docker-compose build &&
UID=$(id -u) GID=$(id -g) docker-compose up -d &&
echo "complete"
