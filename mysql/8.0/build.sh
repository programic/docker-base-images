#!/usr/bin/env bash

docker login
docker build -t programic/mysql:8.0 .
docker push programic/mysql:8.0