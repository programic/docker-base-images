#!/usr/bin/env bash

docker login
docker build --platform linux/amd64 -t programic/php:8.0-fpm-alpine .
docker push programic/php:8.0-fpm-alpine