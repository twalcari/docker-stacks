#!/bin/bash

BASE_DOCKER_TAG="gpulab.ilabt.imec.be:5000/jupyter"
DOCKER_TAG_VERSION=${1:-""}
BASE_CONTAINER=${2:-"nvcr.io/nvidia/cuda:10.0-cudnn7-runtime-ubuntu18.04"}

DARGS="--build-arg BASE_CONTAINER=\"$BASE_CONTAINER\"" make build/base-notebook

declare -a docker_images=("minimal-notebook" \
	"r-notebook" \
	"scipy-notebook" \
	"tensorflow-notebook" \
	"datascience-notebook" \ 
	"pyspark-notebook" \                     
	"all-spark-notebook")

for docker_image in "${docker_images[@]}"
do

	DARGS="-t $BASE_DOCKER_TAG/$docker_image" make "build/$docker_image"
	if [[ -n "$DOCKER_TAG_VERSION" ]]; then
		docker tag "$BASE_DOCKER_TAG/$docker_image:latest" "$BASE_DOCKER_TAG/$docker_image:$DOCKER_TAG_VERSION"
		docker push "$BASE_DOCKER_TAG/$docker_image:$DOCKER_TAG_VERSION"		
		docker push "$BASE_DOCKER_TAG/$docker_image:latest"		
	fi
done

