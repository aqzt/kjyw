#!/bin/bash
## gitlab_rpm 2016-05-16
## http://www.aqzt.com
##email: ppabc@qq.com
##robert yu
##centos 6和centos 7

##按第六列  重复的删除，并保留一行
awk '!arr[$6]++' file

##按第2列和第三  重复的删除，并保留一行
awk '!arr[$2$3]++'  test.log
awk '!arr[$2_$3]++'  test.log

##提取两个文件第一列相同的行
awk -F',' 'NR==FNR{a[$1]=$0;next}NR>FNR{if($1 in a)print $0"\n"a[$1]}' 1.log 2.log

awk 'NR==FNR{a[$1]++}NR>FNR&&a[$1]>1' 111.txt 111.txt

awk 'a[$1]++==1' 

cat 111.txt | awk -F '[:|]' '{print $2}' > 111.txt

##awk 按某个位置的字符分隔的方法
awk -F ":" '{ for(i=1;i<=3;i++) printf("%s:",$i)}'
awk -F':' '{print $1 ":" $2 ":" $3; print $4}'
awk -F':' '{print $1 ":" $2 ":" $3; for(i=1;i<=3;i++)$i=""; print}'

##awk打印用户和密码
cat test.log  |awk -F '[ ]+' '{print $1 "   " $2}'

##排序显示重复项目
cat test.log |awk -F '[ ]+' '{print $1}'| sort | uniq -c | sort -nr

#awk -F '\t'来表示分隔符，比如
awk -F '\t' '{print $1}' file1.txt 

##多个空格分隔的方法
awk -F '[ ]+' '{print $9}'
ls -lh /etc/sysconfig/network-scripts/ifcfg-* | awk -F '[ ]+' '{print $9}'

##指定分隔符既可以为空格，又可以为冒号，那么处理将会变得简单。可以使用正则表达式来指定多个分隔符，格式为 -F'[空格:]+' 如下
awk -F'[ :]+' '{print $NF"\t"$(NF-2)}'  file1.txt 


1、awk '/101/'    file      显示文件file中包含101的匹配行。 
   awk '/101/,/105/'  file 
   awk '$1 == 5'    file 
   awk '$1 == "CT"'    file    注意必须带双引号 
   awk '$1 * $2 >100 '   file  
   awk '$2 >5 && $2<=15'  file


2、awk '{print NR,NF,$1,$NF,}' file     显示文件file的当前记录号、域数和每一行的第一个和最后一个域。 
   awk '/101/ {print $1,$2 + 10}' file       显示文件file的匹配行的第一、二个域加10。 
   awk '/101/ {print $1$2}'  file 
   awk '/101/ {print $1 $2}' file       显示文件file的匹配行的第一、二个域，但显示时域中间没有分隔符。


3、df | awk '$4>1000000 '         通过管道符获得输入，如：显示第4个域满足条件的行。


4、awk -F "|" '{print $1}'   file         按照新的分隔符“|”进行操作。 
   awk  'BEGIN { FS="[: \t|]" } 
   {print $1,$2,$3}'       file         通过设置输入分隔符（FS="[: \t|]"）修改输入分隔符。 

   Sep="|" 
   awk -F $Sep '{print $1}'  file   按照环境变量Sep的值做为分隔符。    
   awk -F '[ :\t|]' '{print $1}' file   按照正则表达式的值做为分隔符，这里代表空格、:、TAB、|同时做为分隔符。 
   awk -F '[][]'    '{print $1}' file   按照正则表达式的值做为分隔符，这里代表[、]


5、awk -f awkfile    file         通过文件awkfile的内容依次进行控制。 
   cat awkfile 
/101/{print "\047 Hello! \047"}    --遇到匹配行以后打印 ' Hello! '.  \047代表单引号。 
{print $1,$2}                      --因为没有模式控制，打印每一行的前两个域。


6、awk '$1 ~ /101/ {print $1}' file         显示文件中第一个域匹配101的行（记录）。


7、awk   'BEGIN { OFS="%"} 
   {print $1,$2}'  file           通过设置输出分隔符（OFS="%"）修改输出格式。


8、awk   'BEGIN { max=100 ;print "max=" max}             BEGIN 表示在处理任意行之前进行的操作。 
   {max=($1 >max ?$1:max); print $1,"Now max is "max}' file           取得文件第一个域的最大值。 
   （表达式1?表达式2:表达式3 相当于： 
   if (表达式1) 
       表达式2 
   else 
       表达式3 
   awk '{print ($1>4 ? "high "$1: "low "$1)}' file 


9、awk '$1 * $2 >100 {print $1}' file         显示文件中第一个域匹配101的行（记录）。


10、awk '{$1 == 'Chi' {$3 = 'China'; print}' file        找到匹配行后先将第3个域替换后再显示该行（记录）。 
    awk '{$7 %= 3; print $7}'  file           将第7域被3除，并将余数赋给第7域再打印。


11、awk '/tom/ {wage=$2+$3; printf wage}' file          找到匹配行后为变量wage赋值并打印该变量。


12、awk '/tom/ {count++;}  
         END {print "tom was found "count" times"}' file            END表示在所有输入行处理完后进行处理。


13、awk 'gsub(/\$/,"");gsub(/,/,""); cost+=$4; 
         END {print "The total is $" cost>"filename"}'    file             gsub函数用空串替换$和,再将结果输出到filename中。 
    1 2 3 $1,200.00 
    1 2 3 $2,300.00 
    1 2 3 $4,000.00 

    awk '{gsub(/\$/,"");gsub(/,/,""); 
    if ($4>1000&&$4<2000) c1+=$4; 
    else if ($4>2000&&$4<3000) c2+=$4; 
    else if ($4>3000&&$4<4000) c3+=$4; 
    else c4+=$4; } 
    END {printf  "c1=[%d];c2=[%d];c3=[%d];c4=[%d]\n",c1,c2,c3,c4}"' file 
    通过if和else if完成条件语句 

    awk '{gsub(/\$/,"");gsub(/,/,""); 
    if ($4>3000&&$4<4000) exit; 
    else c4+=$4; } 
    END {printf  "c1=[%d];c2=[%d];c3=[%d];c4=[%d]\n",c1,c2,c3,c4}"' file 
    通过exit在某条件时退出，但是仍执行END操作。 
    awk '{gsub(/\$/,"");gsub(/,/,""); 
    if ($4>3000) next; 
    else c4+=$4; } 
    END {printf  "c4=[%d]\n",c4}"' file 
    通过next在某条件时跳过该行，对下一行执行操作。 


14、awk '{ print FILENAME,$0 }' file1 file2 file3>fileall              把file1、file2、file3的文件内容全部写到fileall中，格式为 
    打印文件并前置文件名。


15、awk ' $1!=previous { close(previous); previous=$1 }    
    {print substr($0,index($0," ") +1)>$1}' fileall           把合并后的文件重新分拆为3个文件。并与原文件一致。


16、awk 'BEGIN {"date"|getline d; print d}'         通过管道把date的执行结果送给getline，并赋给变量d，然后打印。 


17、awk 'BEGIN {system("echo \"Input your name:\\c\""); getline d;print "\nYour name is",d,"\b!\n"}' 
    通过getline命令交互输入name，并显示出来。 
    awk 'BEGIN {FS=":"; while(getline< "/etc/passwd" >0) { if($1~"050[0-9]_") print $1}}' 
    打印/etc/passwd文件中用户名包含050x_的用户名。 

18、awk '{ i=1;while(i<NF) {print NF,$i;i++}}' file 通过while语句实现循环。 
    awk '{ for(i=1;i<NF;i++) {print NF,$i}}'   file 通过for语句实现循环。     
    type file|awk -F "/" ' 
    { for(i=1;i<NF;i++) 
    { if(i==NF-1) { printf "%s",$i } 
    else { printf "%s/",$i } }}'               显示一个文件的全路径。 
    用for和if显示日期 
    awk  'BEGIN { 
for(j=1;j<=12;j++) 
{ flag=0; 
  printf "\n%d月份\n",j; 
        for(i=1;i<=31;i++) 
        { 
        if (j==2&&i>28) flag=1; 
        if ((j==4||j==6||j==9||j==11)&&i>30) flag=1; 
        if (flag==0) {printf "%02d%02d ",j,i} 
        } 
} 
}'