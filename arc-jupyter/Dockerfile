FROM jupyter/pyspark-notebook:abdb27a6dfbb

# versions
ARG ARC_JUPYTER_VERSION
ARG SCALA_VERSION

# test to ensure all arguments have values then set environment variable
RUN test -n "$ARC_JUPYTER_VERSION"
ENV ARC_JUPYTER_VERSION $ARC_JUPYTER_VERSION
RUN test -n "$SCALA_VERSION"
ENV SCALA_VERSION $SCALA_VERSION

# defaults (see kernel.json for where these are used)
ENV JAVA_OPTS             "-Xmx1g"
ENV BASE_JAVA_OPTS        "-XX:+UseG1GC -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap"

# add the execution time extension
RUN pip install jupyter_contrib_nbextensions && \
  jupyter contrib nbextension install --user && \
  jupyter nbextensions_configurator disable --user && \
  jupyter nbextension enable execute_time/ExecuteTime

# download library and dependencies
USER jovyan
RUN cd /tmp && \
  wget -P /tmp https://git.io/coursier-cli && \
  chmod +x /tmp/coursier-cli && \
  /tmp/coursier-cli bootstrap \
  --embed-files=false \
  --force-version com.fasterxml.jackson.core:jackson-databind:2.6.7.1 \
  --force-version org.json4s:json4s-ast_${SCALA_VERSION}:3.5.3 \
  --force-version org.json4s:json4s-core_${SCALA_VERSION}:3.5.3 \
  --force-version org.json4s:json4s-jackson_${SCALA_VERSION}:3.5.3 \
  --force-version org.json4s:json4s-scalap_${SCALA_VERSION}:3.5.3 \
  --force-version com.google.guava:guava:14.0.1 \
  --force-version org.slf4j:slf4j-log4j12:1.7.16 \
  --exclude org.slf4j:slf4j-nop \
  ai.tripl:arc-jupyter_${SCALA_VERSION}:${ARC_JUPYTER_VERSION} \
  ai.tripl:arc-deltaperiod-config-plugin_${SCALA_VERSION}:1.0.0 \
  ai.tripl:arc-deltalake-pipeline-plugin_${SCALA_VERSION}:1.0.0 \
  ai.tripl:arc-elasticsearch-pipeline-plugin_${SCALA_VERSION}:1.0.0 \
  ai.tripl:arc-kafka-pipeline-plugin_${SCALA_VERSION}:1.0.0 \
  ai.tripl:arc-mongodb-pipeline-plugin_${SCALA_VERSION}:1.0.0 \  
  -o arc && \
  ./arc --install --force && \
  rm /tmp/arc && \
  rm /tmp/coursier-cli

# override default run command to allow JAVA_OPTS injection
COPY kernel.json /home/jovyan/.local/share/jupyter/kernels/arc/kernel.json

# add Download as: Arc (.json) to jupyter notebook
RUN pip install git+https://github.com/tripl-ai/nb_extension_arcexport.git

# ui tweaks
# css to maximise screen realestate
COPY custom.css /home/jovyan/.jupyter/custom/custom.css
# js to set code formatting for arc commmands
COPY custom.js /home/jovyan/.jupyter/custom/custom.js
# copy in settings to fix tabsize
COPY notebook.json /home/jovyan/.jupyter/nbconfig

# disable default save data with notebooks
COPY scrub_output_pre_save.py /tmp/scrub_output_pre_save.py
RUN cat /tmp/scrub_output_pre_save.py >> /etc/jupyter/jupyter_notebook_config.py
