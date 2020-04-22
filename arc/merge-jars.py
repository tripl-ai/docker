#!/usr/bin/python

# this script tries to determine if jars downloaded by coursier already exist in the $SPARK_JARS directory
# and if not copies the jar to $SPARK_JARS
import os, re
from shutil import copyfile

spark_jars = os.environ['SPARK_JARS']
with open('/tmp/coursier/resolved') as lines:
  for line in lines:
    split = line.rstrip().split('/')
    package = split[-3]
    res = [f for f in os.listdir(spark_jars) if re.search(rf'^{package}-[\d].*jar', f)]
    found = len(res) != 0
    src = line.rstrip()
    if not found:
      name = split[-1]
      dst = f'''{spark_jars}/{name}'''
      print(f'copying {src} -> {dst}')
      copyfile(src, dst)
    else:
      print(f'skipping {src}')
      for found in res:
        print(f'- {spark_jars}/{found}')