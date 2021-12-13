#!/usr/bin/env bash

docker login
docker build -t programic/base-php7.4-fpm-alpine:latest .
docker push programic/base-php7.4-fpm-alpine:latest