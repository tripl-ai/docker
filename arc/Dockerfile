ARG FROM_IMAGE
FROM $FROM_IMAGE

# Versions
ARG ARC_VERSION
ARG SPARK_VERSION
ARG HADOOP_VERSION

# test to ensure all arguments have values then set environment variable
RUN test -n "$ARC_VERSION" && test -n "$SPARK_VERSION" && test -n "$HADOOP_VERSION"
ENV ARC_VERSION $ARC_VERSION
ENV SPARK_VERSION $SPARK_VERSION
ENV HADOOP_VERSION $HADOOP_VERSION

ENV SCALA_VERSION         2.12
ENV SPARK_HOME            /opt/spark
ENV SPARK_JARS            /opt/spark/jars
ENV PYTHONPATH            $SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.10.7-src.zip
ENV PYSPARK_PYTHON        python3
ENV LD_LIBRARY_PATH       /usr/lib/x86_64-linux-gnu
ENV OPENBLAS_NUM_THREADS  1
ENV SPARK_DOWNLOAD_URL    https://www.apache.org/dyn/closer.lua/spark
ENV SPARK_CHECKSUM_URL    https://www.apache.org/dist/spark
ENV SPARK_KEYS_URL        https://www.apache.org/dist/spark/KEYS

# copy merge rules
COPY arc/merge-jars.py /tmp/merge-jars.py

# get coursier to download the jars to /tmp/coursier/jars
# --exclude to remove libraires
# include any additional plugins at the bottom
# delete any /tmp/coursier/jars with different versions from the ${SPARK_JARS} directory
# move the jars to ${SPARK_JARS}

RUN \
  # add stretch respository so we can get libgfortran3 needed for openblas
  # see https://github.com/fommil/netlib-java/issues/62 for native blas debug process
  echo "deb http://deb.debian.org/debian stretch main" > /etc/apt/sources.list.d/stretch.list && \
  apt-get update && \
  apt-get install --no-install-recommends -y python3 libopenblas-base libgfortran3 wget gpg gpg-agent && \
  rm /etc/apt/sources.list.d/stretch.list && \
  wget -P /tmp $(wget -qO- https://www.apache.org/dyn/closer.lua/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}.tgz\?as_json | \
  python3 -c "import sys, json; content=json.load(sys.stdin); print(content['preferred']+content['path_info'])") && \
  wget -P /tmp ${SPARK_CHECKSUM_URL}/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}.tgz.asc && \
  wget -P /tmp ${SPARK_KEYS_URL} && \
  gpg --import /tmp/KEYS && \
  gpg --verify /tmp/spark-${SPARK_VERSION}.tgz.asc && \
  tar -xvf /tmp/spark-${SPARK_VERSION}.tgz -C $SPARK_HOME --strip-components=1 spark-${SPARK_VERSION}/python && \
  echo "download cousier and dependencies" && \
  mkdir -p /tmp/coursier/jars && \
  wget -P /tmp/coursier https://git.io/coursier-cli && \
  chmod +x /tmp/coursier/coursier-cli && \
  /tmp/coursier/coursier-cli && \
  echo "download jars" && \
  /tmp/coursier/coursier-cli fetch \
  --cache /tmp/coursier/cache \
  --no-default \
  --repository ivy2Local \
  --repository central \
  --repository sonatype:snapshots \
  --repository https://repository.mulesoft.org/nexus/content/repositories/public \
  --exclude org.slf4j:slf4j-nop \
  ai.tripl:arc_${SCALA_VERSION}:${ARC_VERSION} \
  ai.tripl:arc-cassandra-pipeline-plugin_${SCALA_VERSION}:1.2.0 \
  ai.tripl:arc-dataquality-udf-plugin_${SCALA_VERSION}:1.2.0 \
  ai.tripl:arc-deltalake-pipeline-plugin_${SCALA_VERSION}:1.6.0 \
  ai.tripl:arc-deltaperiod-config-plugin_${SCALA_VERSION}:1.1.0 \
  ai.tripl:arc-graph-pipeline-plugin_${SCALA_VERSION}:1.1.0 \
  ai.tripl:arc-kafka-pipeline-plugin_${SCALA_VERSION}:1.2.0 \
  ai.tripl:arc-mongodb-pipeline-plugin_${SCALA_VERSION}:1.1.0 \
  ai.tripl:arc-sas-pipeline-plugin_${SCALA_VERSION}:1.1.0 \
  # drivers
  com.facebook.presto:presto-jdbc:0.226 \
  com.microsoft.sqlserver:mssql-jdbc:7.4.1.jre8 \
  mysql:mysql-connector-java:8.0.17 \
  org.apache.hadoop:hadoop-aws:${HADOOP_VERSION} \
  org.apache.hadoop:hadoop-azure:${HADOOP_VERSION} \
  org.postgresql:postgresql:42.2.8 \
  com.oracle.ojdbc:ojdbc8:19.3.0.0 \
  com.syncron.amazonaws:simba-athena-jdbc-driver:2.0.2 \
  # blas
  com.github.fommil.netlib:all:1.1.2 \
  > /tmp/coursier/resolved && \
  echo "merging jars" && \
  python3 /tmp/merge-jars.py && \
  ln -s ${SPARK_JARS}/arc_${SCALA_VERSION}-${ARC_VERSION}.jar ${SPARK_JARS}/arc.jar && \
  echo "cleaning up" && \
  # spark
  rm -rf ${SPARK_HOME}/examples \
  ${SPARK_HOME}/data && \
  rm ${SPARK_JARS}/netlib*osx* &&\
  rm ${SPARK_JARS}/netlib*win* &&\
  # apt-get
  apt-get remove -y wget gpg gpg-agent && \
  apt-get autoremove -y && \
  apt-get clean -y && \
  # temp
  rm -rf /root/.gnupg && \
  rm -rf /root/.wget-hsts && \  
  rm -rf /root/.cache && \
  rm -rf /tmp/*

# copy in log4j.properties config file
COPY arc/log4j.properties ${SPARK_HOME}/conf/log4j.properties

# override entrypoint
# original: ENTRYPOINT [ "/opt/entrypoint.sh" ]
ENTRYPOINT []

# set workdir so bin/spark-submit works
WORKDIR ${SPARK_HOME}


