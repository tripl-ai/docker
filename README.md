These are the official Dockerfiles for https://hub.docker.com/r/triplai

## Features

This is a working document and will be updated as more plugins are built and/or plugins support multiple Scala versions.

| Plugin                                                                                              | Scala 2.11          | Scala 2.12              | Notes                                                       |
|-----------------------------------------------------------------------------------------------------|---------------------|-------------------------|-------------------------------------------------------------|
| [arc-cassandra-pipeline-plugin](https://github.com/tripl-ai/arc-cassandra-pipeline-plugin)          | ✔                   |                         | https://datastax-oss.atlassian.net/browse/SPARKC-458        |
| [arc-deltalake-pipeline-plugin](https://github.com/tripl-ai/arc-deltalake-pipeline-plugin)          | ✔                   | ✔                       |                                                             |
| [arc-deltaperiod-config-plugin](https://github.com/tripl-ai/arc-deltaperiod-config-plugin)          | ✔                   | ✔                       |                                                             |
| [arc-elasticsearch-pipeline-plugin](https://github.com/tripl-ai/arc-elasticsearch-pipeline-plugin)  | ✔                   |                         | https://github.com/elastic/elasticsearch-hadoop/issues/1224 |
| [arc-graph-pipeline-plugin](https://github.com/tripl-ai/arc-graph-pipeline-plugin)                  |                     | ✔                       | https://github.com/opencypher/morpheus/issues/917           |
| [arc-kafka-pipeline-plugin](https://github.com/tripl-ai/arc-kafka-pipeline-plugin)                  | ✔                   | ✔                       |                                                             |
| [arc-mongodb-pipeline-plugin](https://github.com/tripl-ai/arc-mongodb-pipeline-plugin)              | ✔                   | ✔                       |                                                             |

## Building

### Build arc

To build the [triplai/arc](https://hub.docker.com/r/triplai/arc) image for Scala 2.11. Change the `SCALA_VERSION` variable for 2.12:

```bash
cd arc

export SCALA_VERSION=2.11
export ARC_VERSION=2.0.0
export SPARK_VERSION=2.4.3 
export HADOOP_VERSION=2.9.2
docker build . \
-f Dockerfile_${SCALA_VERSION} \
--build-arg ARC_VERSION \
--build-arg SPARK_VERSION \
--build-arg HADOOP_VERSION \
-t triplai/arc:arc_${ARC_VERSION}_spark_${SPARK_VERSION}_scala_${SCALA_VERSION}_hadoop_${HADOOP_VERSION}
```

### Build arc-jupyter

To build the [triplai/arc-jupyter](https://hub.docker.com/r/triplai/arc-jupyter) image for Scala 2.11. Change the `SCALA_VERSION` variable for 2.12:

```bash
cd arc-jupyter

export SCALA_VERSION=2.11
export ARC_JUPYTER_VERSION=1.0.0
docker build Dockerfile_${SCALA_VERSION} \
--build-arg ARC_JUPYTER_VERSION \
-t triplai/arc-jupyter:arc-jupyter_${ARC_JUPYTER_VERSION}_scala_${SCALA_VERSION}
```

## Authors/Contributors

- [Mike Seddon](https://github.com/seddonm1)

## License

Arc is released under the [MIT License](https://opensource.org/licenses/MIT).

