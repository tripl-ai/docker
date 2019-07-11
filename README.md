These are the official Dockerfiles for https://hub.docker.com/r/triplai

## Building

### Build arc

To build the [triplai/arc](https://hub.docker.com/r/triplai/arc) image:

```bash
cd arc

export ARC_VERSION=2.0.0
export SPARK_VERSION=2.4.3 
export SCALA_VERSION=2.11
export HADOOP_VERSION=2.9.2
docker build . \
--build-arg ARC_VERSION \
--build-arg SPARK_VERSION \
--build-arg SCALA_VERSION \
--build-arg HADOOP_VERSION \
-t triplai/arc:arc_${ARC_VERSION}_spark_${SPARK_VERSION}_scala_${SCALA_VERSION}_hadoop_${HADOOP_VERSION}
```

### Build arc-jupyter

To build the [triplai/arc-jupyter](https://hub.docker.com/r/triplai/arc-jupyter) image:

```bash
cd arc-jupyter

export ARC_JUPYTER_VERSION=1.0.0
export SCALA_VERSION=2.11
docker build . \
--build-arg ARC_JUPYTER_VERSION \
--build-arg SCALA_VERSION \
-t triplai/arc-jupyter:arc-jupyter_${ARC_JUPYTER_VERSION}_scala_${SCALA_VERSION}
```

## Authors/Contributors

- [Mike Seddon](https://github.com/seddonm1)

## License

Arc is released under the [MIT License](https://opensource.org/licenses/MIT).

