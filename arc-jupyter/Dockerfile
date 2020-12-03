ARG FROM_IMAGE
FROM $FROM_IMAGE

# sudo password if set
ARG PASSWD

# Versions
ARG ARC_JUPYTER_VERSION
RUN test -n "$ARC_JUPYTER_VERSION"

ENV \
  ARC_JUPYTER_VERSION=$ARC_JUPYTER_VERSION \
  JAVA_OPTS="-Xmx1g" \
  BASE_JAVA_OPTS="-XX:+UseG1GC" \
  SPARK_DOWNLOAD_URL=https://www.apache.org/dyn/closer.lua/spark/ \
  SPARK_CHECKSUM_URL=https://www.apache.org/dist/spark \
  SPARK_KEYS_URL=https://www.apache.org/dist/spark/KEYS \
  PATH=$PATH:$SPARK_HOME/bin

# add user
ARG NB_USER="jovyan"
ARG NB_UID="1000"
ARG NB_GID="100"
RUN useradd -m -s /bin/bash -N -u $NB_UID $NB_USER && \
  mkdir -p /home/$NB_USER/.local

# set root password if provided
RUN if [ -n "$PASSWD" ]; then echo "${NB_USER}:${PASSWD}" | chpasswd && usermod -aG sudo ${NB_USER}; fi

# copy local repo for test builds
COPY .m2 /root/.m2

# ui tweaks
# disable default save data with notebooks
COPY arc-jupyter/.jupyter /opt/.jupyter

# copy jar merging script
COPY arc/merge-jars.py /tmp/merge-jars.py

RUN apt-get update && \
  apt-get install --no-install-recommends -y git sudo texlive-xetex texlive-fonts-recommended texlive-generic-recommended wget iputils-ping nodejs npm && \
  echo "install jupyter and dependencies" && \
  pip3 install jupyter jupyterhub pandoc GitPython pyarrow google-cloud-storage gcsfs git+https://github.com/tripl-ai/nb_extension_arcexport.git@0.0.5 && \
  chmod -R 755 /opt/.jupyter && \
  cp -r /opt/.jupyter /home/${NB_USER}/.jupyter && \
  mkdir -p /usr/local/lib/python3.7/dist-packages/notebook/static/components/codemirror/mode/arc && \
  touch /usr/local/lib/python3.7/dist-packages/notebook/static/components/codemirror/mode/arc/arc.js && \
  echo "download jupyterlab" && \
  pip3 install jupyterlab==2.2.9 jupyterlab-git==0.23.2 && \
  jupyter lab build && \
  cd /usr/local/share/jupyter && \
  git clone https://github.com/tripl-ai/arc-jupyterlab-extension.git && \
  cd arc-jupyterlab-extension && \
  git checkout tags/0.0.9 && \
  jupyter labextension disable completer-extension && \
  jupyter labextension disable mathjax-extension && \
  jupyter labextension disable extensionmanager-extension && \
  jlpm install && \
  jupyter labextension link . && \
  jupyter lab build && \
  rm -rf /usr/local/share/jupyter/arc-jupyterlab-extension/node_modules && \
  rm -rf /usr/local/share/jupyter/lab/staging && \
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
  rm ${SPARK_JARS}/cats-kernel_2.12-*.jar && \
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

# disable downloading of files
COPY arc-jupyter/notebook/base/handlers.py /usr/local/lib/python3.7/dist-packages/notebook/base/handlers.py
COPY arc-jupyter/notebook/files/handlers.py /usr/local/lib/python3.7/dist-packages/notebook/files/handlers.py

# inject run command
COPY arc-jupyter/.run_jupyter.sh /home/$NB_USER
RUN chmod +x /home/$NB_USER/.run_jupyter.sh && \
  chown -R $NB_USER:users /home/$NB_USER
USER $NB_USER

# add the kernel to start arc
COPY arc-jupyter/kernel.json /usr/local/share/jupyter/kernels/arc/kernel.json

WORKDIR /home/$NB_USER

EXPOSE 8080

# override the official spark image entry point
ENTRYPOINT [""]
CMD ["/home/jovyan/.run_jupyter.sh"]