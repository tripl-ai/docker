ARG FROM_IMAGE
FROM $FROM_IMAGE

# Versions
ARG ARC_VERSION
ARG SPARK_VERSION
ARG HADOOP_VERSION
ARG SCALA_VERSION
RUN test -n "$ARC_VERSION" && test -n "$SPARK_VERSION" && test -n "$HADOOP_VERSION" && test -n "$SCALA_VERSION"

USER root

ENV \
  ARC_VERSION=$ARC_VERSION \
  SPARK_VERSION=$SPARK_VERSION \
  HADOOP_VERSION=$HADOOP_VERSION \
  SCALA_VERSION=$SCALA_VERSION \
  SPARK_HOME=/opt/spark \
  SPARK_JARS=/opt/spark/jars \
  PYTHONPATH=$SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.10.9-src.zip \
  PYSPARK_PYTHON=python3 \
  LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu \
  OPENBLAS_NUM_THREADS=1 \
  SPARK_DOWNLOAD_URL=https://www.apache.org/dyn/closer.lua/spark \
  SPARK_CHECKSUM_URL=https://www.apache.org/dist/spark \
  SPARK_KEYS_URL=https://dist.apache.org/repos/dist/dev/spark/KEYS

# set locale
RUN \
  apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* && \
  localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV \
  LANG=en_US.UTF-8 \
  LANGUAGE=en_US \
  LC_ALL=en_US.UTF-8

# copy any unmanged libraries
#COPY arc/lib_$SCALA_VERSION/* $SPARK_JARS/

# copy in configurations to fixed location. these are symlinked later
COPY arc/conf /etc/spark/conf

# copy merge rules
COPY arc/merge-jars.py /tmp/merge-jars.py

# copy local repo for test builds
COPY .m2 /root/.m2

# get coursier to download the jars to /tmp/coursier/jars
# --exclude to remove libraires
# include any additional plugins at the bottom
# delete any /tmp/coursier/jars with different versions from the ${SPARK_JARS} directory
# move the jars to ${SPARK_JARS}

RUN set -ex && \
  # add stretch respository so we can get libgfortran3 needed for openblas
  # see https://github.com/fommil/netlib-java/issues/62 for native blas debug process
  echo "deb http://deb.debian.org/debian bullseye main" > /etc/apt/sources.list.d/bullseye.list && \
  apt-get update && \
  apt-get upgrade -y && \
  apt-get install --no-install-recommends -y python3 python3-pip libopenblas-base libgfortran5 wget htop dnsutils gpg gpg-agent && \
  rm /etc/apt/sources.list.d/bullseye.list && \
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
  --repository file:///root/.m2/repository \
  --repository central \
  --repository sonatype:snapshots \
  --repository https://repository.mulesoft.org/nexus/content/repositories/public \
  --exclude org.slf4j:slf4j-nop \
  --exclude io.grpc:grpc-netty \
  --exclude org.scala-lang:scala-library \
  --force-version com.amazonaws:aws-java-sdk-bundle:1.11.1034 \
  ai.tripl:arc_${SCALA_VERSION}:${ARC_VERSION} \
  #ai.tripl:arc-debezium-pipeline-plugin_${SCALA_VERSION}:1.5.0 \
  #ai.tripl:arc-deltalake-pipeline-plugin_${SCALA_VERSION}:3.0.0 \
  #ai.tripl:arc-deltaperiod-config-plugin_${SCALA_VERSION}:1.7.0 \
  #ai.tripl:arc-kafka-pipeline-plugin_${SCALA_VERSION}:1.15.1 \
  # drivers
  #com.facebook.presto:presto-jdbc:0.280 \
  #com.microsoft.sqlserver:mssql-jdbc:12.2.0.jre8 \
  com.mysql:mysql-connector-j:8.3.0 \
  org.postgresql:postgresql:42.7.1 \
  #com.oracle.database.jdbc:ojdbc8:21.9.0.0 \
  org.apache.hadoop:hadoop-aws:${HADOOP_VERSION} \
  org.apache.hadoop:hadoop-azure:${HADOOP_VERSION} \
  # blas
  #com.github.fommil.netlib:all:1.1.2 \
  # grpc override
  io.grpc:grpc-netty-shaded:1.30.2 \
  > /tmp/coursier/resolved && \
  echo "merging jars" && \
  python3 /tmp/merge-jars.py && \
  #wget -P ${SPARK_JARS} https://github.com/GoogleCloudDataproc/hadoop-connectors/releases/download/v2.2.12/gcs-connector-hadoop3-2.2.12-shaded.jar && \
  wget -P ${SPARK_JARS} https://s3.amazonaws.com/athena-downloads/drivers/JDBC/SimbaAthenaJDBC-2.1.3.1002/AthenaJDBC42-2.1.3.1002.jar && \
  ln -s ${SPARK_JARS}/arc_${SCALA_VERSION}-${ARC_VERSION}.jar ${SPARK_JARS}/arc.jar && \
  # copy the conf overrides as kuberentes may override this directory
  rm -rf ${SPARK_HOME}/conf && \
  mkdir -p ${SPARK_HOME}/conf && \
  cp -r /etc/spark/conf/* ${SPARK_HOME}/conf && \
  echo "python dependencies" && \
  pip3 install --upgrade pip setuptools==49.6.0 && \
  pip3 install pandas numpy scipy pyarrow koalas kubernetes && \
  echo "cleaning up" && \
  # spark
  rm -rf ${SPARK_HOME}/examples \
  ${SPARK_HOME}/data && \
  #rm ${SPARK_JARS}/netlib*osx* &&\
  #rm ${SPARK_JARS}/netlib*win* &&\
  # apt-get
  apt-get remove -y wget gpg gpg-agent && \
  apt-get autoremove -y && \
  apt-get clean -y && \
  # temp
  rm -rf /root/.gnupg && \
  rm -rf /root/.wget-hsts && \
  rm -rf /root/.cache && \
  rm -rf /root/.m2 && \
  rm -rf /tmp/*

# set workdir so bin/spark-submit works
WORKDIR ${SPARK_HOME}
