These are the official Dockerfiles for https://github.com/orgs/tripl-ai/packages

## Building

Then the official Spark `k8s` Dockerfile is used to built a generic Spark image. Both images below then use that image as their base.

It can be build like:

```bash
./bin/docker-image-tool.sh -r ghcr.io/tripl-ai -t spark_3.1.2_scala_2.12_hadoop_3.2.0 build
```

### Build arc

To build the [triplai/arc](https://github.com/orgs/tripl-ai/packages/container/package/arc) image for Scala 2.12:

```bash
export ARC_VERSION=4.2.0
export SPARK_VERSION=3.3.4
export SCALA_VERSION=2.12
export HADOOP_VERSION=3.3.2
export ARC_JUPYTER_VERSION=3.16.0
export ARC_IMAGE_VERSION=$(cat arc/version)
export ARC_JUPYTER_IMAGE_VERSION=$(cat arc-jupyter/version)

export FROM_IMAGE=ghcr.io/tripl-ai/spark:spark_${SPARK_VERSION}_scala_${SCALA_VERSION}_hadoop_${HADOOP_VERSION}
docker buildx build --platform linux/amd64,linux/arm64 . \
  -f arc/Dockerfile \
  --build-arg FROM_IMAGE \
  --build-arg ARC_VERSION \
  --build-arg SCALA_VERSION \
  --build-arg SPARK_VERSION \
  --build-arg HADOOP_VERSION \
  -t ghcr.io/tripl-ai/arc:arc_${ARC_VERSION}_spark_${SPARK_VERSION}_scala_${SCALA_VERSION}_hadoop_${HADOOP_VERSION}_${ARC_IMAGE_VERSION}
```
### Build arc-jupyter

To build the [triplai/arc-jupyter](https://github.com/orgs/tripl-ai/packages/container/package/arc-jupyter) image for Scala 2.12:

```bash
export ARC_VERSION=4.1.0
export SPARK_VERSION=3.1.2
export SCALA_VERSION=2.12
export HADOOP_VERSION=3.2.0
export ARC_JUPYTER_VERSION=3.15.1
export ARC_IMAGE_VERSION=$(cat arc/version)
export ARC_JUPYTER_IMAGE_VERSION=$(cat arc-jupyter/version)
export NB_USER=jovyan
export ALLOW_EXPORT=true

export FROM_IMAGE=ghcr.io/tripl-ai/arc:arc_${ARC_VERSION}_spark_${SPARK_VERSION}_scala_${SCALA_VERSION}_hadoop_${HADOOP_VERSION}_${ARC_IMAGE_VERSION}
docker buildx build --platform linux/amd64,linux/arm64 . \
-f arc-jupyter/Dockerfile \
--build-arg FROM_IMAGE \
--build-arg ARC_JUPYTER_VERSION \
--build-arg NB_USER \
--build-arg ALLOW_EXPORT \
-t ghcr.io/tripl-ai/arc-jupyter:arc-jupyter_${ARC_JUPYTER_VERSION}_scala_${SCALA_VERSION}_hadoop_${HADOOP_VERSION}_${ARC_JUPYTER_IMAGE_VERSION}
```

## Authors/Contributors

- [Mike Seddon](https://github.com/seddonm1)

## License

Arc is released under the [MIT License](https://opensource.org/licenses/MIT).
