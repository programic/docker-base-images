#!/usr/bin/env bash

docker login
docker build -t programic/php:7.4-fpm-alpine .
docker push programic/php:7.4-fpm-alpine