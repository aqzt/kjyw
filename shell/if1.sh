#!/bin/bash

##或
if [ "$b" = 11 ] || [ "$b" = "22" ];then
　　echo $a
fi
##且的表达方式
if [ "$b" = 11 ] && [ "$b" = "22" ];then
　　echo $b
fi


project="aaaaa"
if [[ ${project} =~ "aaa" ]]; then
  cp aaa.txt bbb.txt
fi
if [[ ${project} =~ "ccc" ]]; then
  cp aaa.txt ccc.txt
fi


project="aaaaa"
if [[ ${project} =~ "aaa" ]]; then
  echo "aaa111"
else
  echo "aaa222"
fi
if [[ ${project} =~ "ccc" ]]; then
  echo "aaa555"
else
  echo "aaa666"
fi


