ARG FROM_IMAGE
FROM $FROM_IMAGE

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

# add user
ARG NB_USER="jovyan"
ARG NB_UID="1000"
ARG NB_GID="100"
RUN useradd -m -s /bin/bash -N -u $NB_UID $NB_USER && \
  mkdir -p /home/$NB_USER/.jupyter && \
  mkdir -p /home/$NB_USER/.local

# disable default save data with notebooks
COPY arc-jupyter/scrub_output_pre_save.py /tmp/scrub_output_pre_save.py

# copy local repo for test builds
COPY .m2 /root/.m2

# ui tweaks
COPY arc-jupyter/custom.js /root/.jupyter/custom/custom.js
COPY arc-jupyter/custom.css /root/.jupyter/custom/custom.css
COPY arc-jupyter/notebook.json /root/.jupyter/nbconfig/notebook.json

# add the kernel to start arc
COPY arc-jupyter/kernel.json /root/.local/share/jupyter/kernels/arc/kernel.json

COPY arc/merge-jars.py /tmp/merge-jars.py

RUN apt-get update && \
  apt-get install --no-install-recommends -y git texlive-xetex texlive-fonts-recommended texlive-generic-recommended wget && \
  echo "install jupyter and dependencies" && \
  pip3 install jupyter pandoc jupyter_contrib_nbextensions GitPython git+https://github.com/tripl-ai/nb_extension_arcexport.git@0.0.3 && \
  jupyter contrib nbextension install --system && \
  jupyter nbextensions_configurator disable --system && \
  jupyter nbextension enable execute_time/ExecuteTime --system && \
  jupyter notebook --generate-config && \
  cat /tmp/scrub_output_pre_save.py >> /root/.jupyter/jupyter_notebook_config.py && \
  cp -r /root/.jupyter/* /home/jovyan/.jupyter && \
  cp -r /root/.local/* /home/jovyan/.local && \
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
  --repository file:///root/.m2/repository \
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
  rm -rf /root/.m2 && \
  rm -rf /tmp/*

RUN chown -R $NB_USER:users /home/$NB_USER
USER $NB_USER

WORKDIR /home/$NB_USER
