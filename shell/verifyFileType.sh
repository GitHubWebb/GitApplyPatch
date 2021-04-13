#!/bin/bash
# author  wangweixu
# data    2021年04月09日11:19:08
# note    验证文件类型

file=$1
if [[ -z $file ]]; then
  echo "Usage: $0 filename"
  exit 0
fi
if [ -d $file ]; then
  echo $file is a directory
  isFileDiff=false
else
  echo $file is a file
  isFileDiff=true
fi
