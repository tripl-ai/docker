# define base image
ARG PYTHON_VERSION
FROM python:$PYTHON_VERSION

# add boto3
ARG BOTO3_VERSION
RUN pip install boto3==$BOTO3_VERSION
