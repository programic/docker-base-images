#!/usr/bin/env bash

docker login
docker build --platform linux/amd64 -t programic/wordpress:5.9 .
docker push programic/wordpress:5.9