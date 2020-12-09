These are the official Dockerfiles for https://hub.docker.com/r/triplai

## Features

This is a working document and will be updated as more plugins are built and/or plugins support multiple Scala versions.

| Plugin                                                                                              | Scala 2.11          | Scala 2.12              | Notes                                                           |
|-----------------------------------------------------------------------------------------------------|---------------------|-------------------------|-----------------------------------------------------------------|
| [arc-cassandra-pipeline-plugin](https://github.com/tripl-ai/arc-cassandra-pipeline-plugin)          | ✔                   | ✔                       |                                                                 |
| [arc-deltalake-pipeline-plugin](https://github.com/tripl-ai/arc-deltalake-pipeline-plugin)          | ✔                   | ✔                       |                                                                 |
| [arc-deltaperiod-config-plugin](https://github.com/tripl-ai/arc-deltaperiod-config-plugin)          | ✔                   | ✔                       |                                                                 |
| [arc-elasticsearch-pipeline-plugin](https://github.com/tripl-ai/arc-elasticsearch-pipeline-plugin)  | ✔                   |                         | https://github.com/elastic/elasticsearch-hadoop/issues/1224     |
| [arc-graph-pipeline-plugin](https://github.com/tripl-ai/arc-graph-pipeline-plugin)                  |                     | ✔                       | https://github.com/opencypher/morpheus/issues/917               |
| [arc-kafka-pipeline-plugin](https://github.com/tripl-ai/arc-kafka-pipeline-plugin)                  | ✔                   | ✔                       |                                                                 |
| [arc-mongodb-pipeline-plugin](https://github.com/tripl-ai/arc-mongodb-pipeline-plugin)              | ✔                   | ✔                       |                                                                 |
| [arc-sas-pipeline-plugin](https://github.com/tripl-ai/arc-sas-pipeline-plugin)                      | ✔                   | ✔                       |                                                                 |

## Building

Then the official Spark `k8s` Dockerfile is used to built a generic Spark image. Both images below then use that image as their base.

It can be build like:

```bash
./bin/docker-image-tool.sh -r ghcr.io/tripl-ai -t spark_3.0.1_scala_2.12_hadoop_3.2.0 build
```

### Build arc

To build the [triplai/arc](https://hub.docker.com/r/triplai/arc) image for Scala 2.12:

```bash
export ARC_VERSION=3.6.2
export SPARK_VERSION=3.0.1
export SCALA_VERSION=2.12
export HADOOP_VERSION=3.2.0
export ARC_JUPYTER_VERSION=3.11.0
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
```
### Build arc-jupyter

To build the [triplai/arc-jupyter](https://hub.docker.com/r/triplai/arc-jupyter) image for Scala 2.12:

```bash
export ARC_VERSION=3.6.2
export SPARK_VERSION=3.0.1
export SCALA_VERSION=2.12
export HADOOP_VERSION=3.2.0
export ARC_JUPYTER_VERSION=3.11.0
export ARC_IMAGE_VERSION=$(cat arc/version)
export ARC_JUPYTER_IMAGE_VERSION=$(cat arc-jupyter/version)

export FROM_IMAGE=ghcr.io/tripl-ai/arc:arc_${ARC_VERSION}_spark_${SPARK_VERSION}_scala_${SCALA_VERSION}_hadoop_${HADOOP_VERSION}_${ARC_IMAGE_VERSION}
docker build . \
-f arc-jupyter/Dockerfile \
--build-arg FROM_IMAGE \
--build-arg ARC_JUPYTER_VERSION \
-t ghcr.io/tripl-ai/arc-jupyter:arc-jupyter_${ARC_JUPYTER_VERSION}_scala_${SCALA_VERSION}_hadoop_${HADOOP_VERSION}_${ARC_JUPYTER_IMAGE_VERSION}
```

## Authors/Contributors

- [Mike Seddon](https://github.com/seddonm1)

## License

Arc is released under the [MIT License](https://opensource.org/licenses/MIT).
