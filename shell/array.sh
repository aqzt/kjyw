#!/bin/bash
##############
##Author: yul1
##Date: 2019-09-13 11:29:25
##LastEditors: yul1
##LastEditTime: 2019-09-13 11:32:32
##Description: 
##############

#初始化定义三个数组
arry1=(A B C)
arry2=(D E F)
arry3=(G H I)
#
#使用for循环来读取数组中元素的个数，每次读取完一个数组将其打印到屏幕上并继续读取
for ((i=0;i<4;i++))
   do
     eval value=\${arry${i}[@]}
      for element in ${value}
         do
           echo -e ${value}
           continue 2
         done
    done
echo

#定义三个一维数组
array1="A B C"
array2="D E F"
array3="G H I"
#
#使用for语句来循环读取所定义的数组中的元素并暂存到变量i中
#将暂存在变量i中的元素赋予变量value
#使用for语句读取变量value中的值 每次读取完后都打印到标准输出直到读取完成
for i in array1 array2 array3
   do
     eval value=\$$i
      for j in $value
         do
          echo -e $value
          continue 2
      done
done


#初始化第一个数组
array2=(
   element2
   element3
   element4
)
#初始化第二个数组
array3=(
   element5 element6 element7
)
#定义一个函数 将所定义的两个一维数组组合成一个二维数组并显示到屏幕上
ARRAY()
{
  echo
  echo ">>Two-dimensional array<<"
  echo
  echo "${array2[*]}"
  echo "${array3[*]}"
}
#
ARRAY
echo array



declare -i j=0
declare -i limit=4
#
#初始化一个一维数组
array=(34 35 36 37 38 39)
#
echo "Two-dimensional array"
#使用while循环完成对一维数组元素的读取 并将读取的元素重新组成一个二维数组后输出
while [ $j -lt $limit ]
    do
#对数组array中的元素每次都从第$j个元素开始读取且读取的数目为3
      echo "${array[*]:$j:3}"       
      let j+=2
      let j++
done
echo

