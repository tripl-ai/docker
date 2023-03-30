#!/bin/bash

export ARC_VERSION=4.1.0
export SPARK_VERSION=3.3.2
export SCALA_VERSION=2.12
export HADOOP_VERSION=3.3.2
export ARC_JUPYTER_VERSION=3.15.1
export ARC_IMAGE_VERSION=$(cat arc/version)
export ARC_JUPYTER_IMAGE_VERSION=$(cat arc-jupyter/version)

export FROM_IMAGE=ghcr.io/tripl-ai/spark:spark_${SPARK_VERSION}_scala_${SCALA_VERSION}_hadoop_${HADOOP_VERSION}
docker build . \
  -f arc/Dockerfile \
  --build-arg FROM_IMAGE \
  --build-arg ARC_VERSION \
  --build-arg SCALA_VERSION \
  --build-arg SPARK_VERSION \
  --build-arg HADOOP_VERSION \
  -t ghcr.io/tripl-ai/arc:arc_${ARC_VERSION}_spark_${SPARK_VERSION}_scala_${SCALA_VERSION}_hadoop_${HADOOP_VERSION}_${ARC_IMAGE_VERSION}