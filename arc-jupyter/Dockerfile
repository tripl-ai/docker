FROM triplai/arc:arc_2.8.1_spark_2.4.5_scala_2.12_hadoop_2.9.2_1.0.0

# Versions
ARG ARC_JUPYTER_VERSION

# test to ensure all arguments have values then set environment variable
RUN test -n "$ARC_JUPYTER_VERSION"
ENV ARC_JUPYTER_VERSION $ARC_JUPYTER_VERSION

ENV JAVA_OPTS             "-Xmx1g"
ENV BASE_JAVA_OPTS        "-XX:+UseG1GC -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap"

ENV SPARK_DOWNLOAD_URL    https://www.apache.org/dyn/closer.lua/spark/
ENV SPARK_CHECKSUM_URL    https://www.apache.org/dist/spark
ENV SPARK_KEYS_URL        https://www.apache.org/dist/spark/KEYS
ENV PATH                  $PATH:$SPARK_HOME/bin

COPY arc-jupyter/2.1.0 /root/.ivy2/local/ai.tripl/arc-jupyter_2.12/2.1.0

# disable default save data with notebooks
COPY arc-jupyter/scrub_output_pre_save.py /tmp/scrub_output_pre_save.py
COPY arc/merge-jars.py /tmp/merge-jars.py

RUN apt-get update && \
  apt-get install --no-install-recommends -y python3-pip git wget && \
  echo "install jupyter and dependencies" && \
  pip3 install --upgrade pip setuptools && \
  pip3 install jupyter pandas numpy scipy pyarrow jupyter_contrib_nbextensions GitPython git+https://github.com/tripl-ai/nb_extension_arcexport.git@0.0.2 && \
  jupyter contrib nbextension install --system && \
  jupyter nbextensions_configurator disable --system && \
  jupyter nbextension enable execute_time/ExecuteTime --system && \
  jupyter notebook --generate-config && \
  cat /tmp/scrub_output_pre_save.py >> /root/.jupyter/jupyter_notebook_config.py && \
  mkdir -p /usr/local/lib/python3.7/dist-packages/notebook/static/components/codemirror/mode/arc && \
  touch /usr/local/lib/python3.7/dist-packages/notebook/static/components/codemirror/mode/arc/arc.js && \
  echo "download cousier and dependencies" && \
  mkdir -p /tmp/coursier/jars && \
  wget -P /tmp/coursier https://git.io/coursier-cli && \
  chmod +x /tmp/coursier/coursier-cli && \
  /tmp/coursier/coursier-cli && \
  echo "download jars" && \
  /tmp/coursier/coursier-cli fetch \
  --no-default \
  --repository ivy2Local \
  --repository central \
  --repository sonatype:snapshots \
  --repository https://repository.mulesoft.org/nexus/content/repositories/public \
  --exclude org.slf4j:slf4j-nop \
  ai.tripl:arc-jupyter_${SCALA_VERSION}:${ARC_JUPYTER_VERSION} \
  > /tmp/coursier/resolved && \
  echo "merging jars" && \
  # override the jar included with spark
  rm ${SPARK_JARS}/shapeless_${SCALA_VERSION}-*.jar && \
  python3 /tmp/merge-jars.py && \
  echo "cleaning up" && \
  apt-get remove -y wget && \
  apt-get autoremove -y && \
  apt-get clean -y && \
  rm -rf /root/.gnupg && \
  rm -rf /root/.wget-hsts && \
  rm -rf /root/.cache && \
  rm -rf /tmp/*

ARG NB_USER="jovyan"
ARG NB_UID="1000"
ARG NB_GID="100"

RUN useradd -m -s /bin/bash -N -u $NB_UID $NB_USER
WORKDIR /home/$NB_USER


# add the kernel to start arc
COPY arc-jupyter/kernel.json /home/$NB_USER/.local/share/jupyter/kernels/arc/kernel.json

# ui tweaks
COPY arc-jupyter/custom.js /home/$NB_USER/.jupyter/custom/custom.js
COPY arc-jupyter/custom.css /home/$NB_USER/.jupyter/custom/custom.css
COPY arc-jupyter/notebook.json /home/$NB_USER/.jupyter/nbconfig

RUN chown -R $NB_USER:users /home/$NB_USER
USER $NB_USER

ENTRYPOINT jupyter notebook --ip=0.0.0.0 --no-browser --NotebookApp.password='' --NotebookApp.token=''