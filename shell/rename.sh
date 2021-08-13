#!/bin/bash

#rename

#批量更改文件扩展名 
rename 's//.txt//.ext/' * 

#批量删除文件扩展名 
rename 's//.txt//' *

#批量添加文件扩展名 
rename 's/$//.txt/' * 

#按自己的方式批量重命名文件 
rename 's/(/d)/第$1 章/' * 

#修改*.txt文件名，里面含有aaa改为bbb
rename "aaa" "bbb" *.txt

#把所有文件的文件名改为小写
rename 'y/A-Z/a-z/' *

#使用rename将.log改为.jpg
rename ".log" ".jpg" *

#批量使用sed改文件后缀，改为.log
ls|sed -nr "s#(^.*[0-9].)(.*)#mv & \1log#gp"
ls|sed -nr "s#(^.*[0-9].)(.*)#mv & \1log#gp"|bash

#使用for再配合替换字符串
for name in `ls *.log`;
do
echo "mv $name ${name/.log/.txt}"
done

将 abcd.txt 重命名为 abcd_aaa1.txt
for var in *.txt; do mv "$var" "$var.jpg_aaa1.txt"; done

将 abcd_aaa.txt 重命名为 abcd_bbb.jpg
for var in *.txt; do mv "var" "{var%_efg1.txt}_lmn.jpg"; done

把文件名中所有小写字母改为大写字母
for var in `ls`; do mv -f "var"`echo"var" |tr a-z A-Z`; done
