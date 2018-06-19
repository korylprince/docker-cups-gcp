#!/bin/bash

version=$1

tag="korylprince/cups-gcp-gcp:$version"

docker build --no-cache --tag "$tag" .

docker push "$tag"

if [ "$2" = "latest" ]; then
    docker tag "$tag" "korylprince/cups-gcp-gcp:latest"
    docker push "korylprince/cups-gcp-gcp:latest"
fi
