#!/bin/bash
##############
##Author: yul1
##Date: 2019-09-13 11:29:25
##LastEditors: yul1
##LastEditTime: 2019-09-13 12:03:10
##Description: 
##############

#在示例中，行分隔符（第1维）是空格字符。为了引入字段分隔符（第二维），使用标准unix工具tr。用于附加尺寸的附加分隔符可以以相同的方式使用。

#当然，这种方法的性能不是很好，但是如果性能是不是一个标准，这种做法是非常通用的，可以解决很多问题：

array2d="1.1:1.2:1.3 2.1:2.2 3.1:3.2:3.3:3.4" 

function process2ndDimension { 
    for dimension2 in $* 
    do 
     echo -n $dimension2 " " 
    done 
    echo 
} 

function process1stDimension { 
    for dimension1 in $array2d 
    do 
     process2ndDimension `echo $dimension1 | tr : " "` 
    done 
} 

process1stDimension 

##该样品的输出是这样的：

##1.1  1.2  1.3  
##2.1  2.2  
##3.1  3.2  3.3  3.4 




#!/bin/bash
##提取控制台上w命令给出的：USER,TTY和FROM值.在bash中我试图获取此输出并将这些值放入多维数组(或只是一个带空格分隔符的数组).
w|awk '{if(NR > 2) print $1,$2,$3}' | while read line
do
     USERS+=("$line")
     echo ${#USERS[@]}
done
echo ${#USERS[@]}

#!/bin/bash
USERS=()
shopt -s lastpipe
w | awk '{if(NR > 2) print $1,$2,$3}' | while read line; do
  USERS+=("$line")
done
echo ${#USERS[@]}

##可以使用process substitution而不是管道,以便read命令在主shell进程中运行.

#!/bin/bash
USERS=()
while read line; do
  USERS+=("$line")
done < <(w | awk '{if(NR > 2) print $1,$2,$3}')
echo ${#USERS[@]}

##可以使用可移植方法,该方法适用于没有进程暂停或ksh / zsh行为的shell,例如Bourne,dash和pdksh. (对于数组,您仍然需要(pd)ksh,bash或zsh.)运行需要管道内管道数据的所有内容.

#!/bin/bash
USERS=()
shopt -s lastpipe
w | awk '{if(NR > 2) print $1,$2,$3}' | {
  while read line; do
    USERS+=("$line")
  done
  echo ${#USERS[@]}
}