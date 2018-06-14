#!/bin/bash

version=$1

tag="korylprince/cups-gcp-resumer:$version"

docker build --no-cache --build-arg "VERSION=$version" --tag "$tag" .

docker push "$tag"

if [ "$2" = "latest" ]; then
    docker tag "$tag" "korylprince/cups-gcp-resumer:latest"
    docker push "korylprince/cups-gcp-resumer:latest"
fi
