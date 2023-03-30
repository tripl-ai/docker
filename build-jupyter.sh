#!/bin/bash

export ARC_VERSION=4.1.0
export SPARK_VERSION=3.3.2
export SCALA_VERSION=2.12
export HADOOP_VERSION=3.3.2
export ARC_JUPYTER_VERSION=3.15.1
export ARC_IMAGE_VERSION=$(cat arc/version)
export ARC_JUPYTER_IMAGE_VERSION=$(cat arc-jupyter/version)
export NB_USER=jovyan
export ALLOW_EXPORT=true

export FROM_IMAGE=ghcr.io/tripl-ai/arc:arc_${ARC_VERSION}_spark_${SPARK_VERSION}_scala_${SCALA_VERSION}_hadoop_${HADOOP_VERSION}_${ARC_IMAGE_VERSION}
docker build . \
-f arc-jupyter/Dockerfile \
--build-arg FROM_IMAGE \
--build-arg ARC_JUPYTER_VERSION \
--build-arg NB_USER \
--build-arg ALLOW_EXPORT \
-t ghcr.io/tripl-ai/arc-jupyter:arc-jupyter_${ARC_JUPYTER_VERSION}_scala_${SCALA_VERSION}_hadoop_${HADOOP_VERSION}_${ARC_JUPYTER_IMAGE_VERSION}