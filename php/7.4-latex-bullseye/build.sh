#!/usr/bin/env bash

docker login

# Building FPM version
docker build --build-arg type=fpm -t programic/php:7.4-fpm-latex-bullseye .
docker push programic/php:7.4-fpm-latex-bullseye

# Building CLI version
docker build --build-arg type=cli -t programic/php:7.4-cli-latex-bullseye .
docker push programic/php:7.4-cli-latex-bullseye