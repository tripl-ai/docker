# this script tries to determine if jars downloaded by coursier already exist in the $SPARK_JARS directory
# and if not copies the jar to $SPARK_JARS
import os, re
from shutil import copyfile

with open('/tmp/coursier/resolved') as lines:
  for line in lines:
    split = line.rstrip().split('/')
    package = split[-3]
    res = [f for f in os.listdir(os.environ['SPARK_JARS']) if re.search(rf'^{package}-[\d].*jar', f)]
    found = len(res) != 0
    if not found:
      src = line.rstrip()
      name = split[-1]
      dst = f'''{os.environ['SPARK_JARS']}/{name}'''
      print(f'{src} -> {dst}')
      copyfile(src, dst)