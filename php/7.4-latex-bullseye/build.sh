#!/usr/bin/env bash

docker login

# Building FPM version
docker build --build-arg TYPE=fpm -t programic/php:7.4-fpm-latex-bullseye .
docker push programic/php:7.4-fpm-latex-bullseye

# Building CLI version
docker build --build-arg TYPE=cli -t programic/php:7.4-cli-latex-bullseye .
docker push programic/php:7.4-cli-latex-bullseye