#!/usr/bin/env bash

docker login
docker build -t programic/base-php8.0-fpm-alpine:latest .
docker push programic/base-php8.0-fpm-alpine:latest