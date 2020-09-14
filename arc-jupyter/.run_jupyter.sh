#!/bin/bash
echo "arc: ${ARC_VERSION} arc-jupyter: ${ARC_JUPYTER_VERSION} spark: ${SPARK_VERSION} hadoop: ${HADOOP_VERSION}"
echo ""
/usr/local/bin/jupyter lab --allow-root --ip 0.0.0.0 --config=/home/jovyan/.jupyter/jupyter_notebook_config.py
