#!/usr/bin/env bash

docker login
docker build -t programic/php:8.1-fpm-alpine .
docker push programic/php:8.1-fpm-alpine