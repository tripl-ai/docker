#!/bin/bash
echo "
    ___                     __                  __
   /   |  __________       / /_  ______  __  __/ /____  _____
  / /| | / ___/ ___/  __  / / / / / __ \/ / / / __/ _ \/ ___/
 / ___ |/ /  / /__   / /_/ / /_/ / /_/ / /_/ / /_/  __/ /
/_/  |_/_/   \___/   \____/\__,_/ .___/\__, /\__/\___/_/
                               /_/    /____/

arc: ${ARC_VERSION} arc-jupyter: ${ARC_JUPYTER_VERSION} spark: ${SPARK_VERSION} hadoop: ${HADOOP_VERSION}
"
/usr/local/bin/jupyter lab --allow-root --ip 0.0.0.0 --config=/home/jovyan/.jupyter/jupyter_notebook_config.py
