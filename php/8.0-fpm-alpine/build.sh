#!/usr/bin/env bash

docker login
docker build -t programic/php:8.0-fpm-alpine .
docker push programic/php:8.0-fpm-alpine