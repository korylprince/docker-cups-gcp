#!/bin/bash

version=$1

tag="korylprince/cups-gcp-cups:$version"

docker build --no-cache --build-arg "VERSION=${version:1}" --tag "$tag" .

docker push "$tag"

if [ "$2" = "latest" ]; then
    docker tag "$tag" "korylprince/cups-gcp-cups:latest"
    docker push "korylprince/cups-gcp-cups:latest"
fi
