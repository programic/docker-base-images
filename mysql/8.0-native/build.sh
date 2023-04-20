#!/usr/bin/env bash

docker login
docker buildx build --push --platform linux/arm64/v8,linux/amd64 --tag programic/mysql:8.0-native .
