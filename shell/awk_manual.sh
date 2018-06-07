常用awk命令 

awk 用法：awk ' pattern {action} '  

变量名	 含义 
ARGC	 命令行变元个数 
ARGV	 命令行变元数组 
FILENAME	当前输入文件名 
FNR	 当前文件中的记录号 
FS	 输入域分隔符，默认为一个空格 
RS	 输入记录分隔符 
NF	 当前记录里域个数 
NR	 到目前为止记录数 
OFS	 输出域分隔符 
ORS	 输出记录分隔符 
_________________________________________________________________________________

du -sk /data/ |gawk '$1>1024*1024 {print $1/1024/1024"G"} {print $1/1024"M"}'
3.15131G
3226.94M
精确到M和G 小数点....


du -sk /data/ |gawk '{print $1/1024}'  统计显示精确到M

du -sk /data/ |gawk '{print $1/1024/1024}' 统计显示精确到G
_________________________________________________________________________________

1、awk '/101/'               file 显示文件file中包含101的匹配行。 
   awk '/101/,/105/'         file 
   awk '$1 == 5'             file 
   awk '$1 == "CT"'          file 注意必须带双引号 
   awk '$1 * $2 >100 '       file  
   awk '$2 >5 && $2<=15'     file


2、awk '{print NR,NF,$1,$NF,}' file 显示文件file的当前记录号、域数和每一行的第一个和最后一个域。 
   awk '/101/ {print $1,$2 + 10}' file 显示文件file的匹配行的第一、二个域加10。 
   awk '/101/ {print $1$2}'  file 
   awk '/101/ {print $1 $2}' file 显示文件file的匹配行的第一、二个域，但显示时域中间没有分隔符。


3、df | awk '$4>1000000 '         通过管道符获得输入，如：显示第4个域满足条件的行。


4、awk -F "|" '{print $1}'   file 按照新的分隔符“|”进行操作。 
   awk  'BEGIN { FS="[: \t|]" } 
   {print $1,$2,$3}' 	     file 通过设置输入分隔符（FS="[: \t|]"）修改输入分隔符。 

   Sep="|" 
   awk -F $Sep '{print $1}'  file 按照环境变量Sep的值做为分隔符。    
   awk -F '[ :\t|]' '{print $1}' file 按照正则表达式的值做为分隔符，这里代表空格、:、TAB、|同时做为分隔符。 
   awk -F '[][]'    '{print $1}' file 按照正则表达式的值做为分隔符，这里代表[、]


5、awk -f awkfile 	     file 通过文件awkfile的内容依次进行控制。 
   cat awkfile 
/101/{print "\047 Hello! \047"} --遇到匹配行以后打印 ' Hello! '.\047代表单引号。 
{print $1,$2}                   --因为没有模式控制，打印每一行的前两个域。


6、awk '$1 ~ /101/ {print $1}' file 显示文件中第一个域匹配101的行（记录）。


7、awk   'BEGIN { OFS="%"} 
   {print $1,$2}'           file 通过设置输出分隔符（OFS="%"）修改输出格式。


8、awk   'BEGIN { max=100 ;print "max=" max}             BEGIN 表示在处理任意行之前进行的操作。 
   {max=($1 >max ?$1:max); print $1,"Now max is "max}' file 取得文件第一个域的最大值。 
   （表达式1?表达式2:表达式3 相当于： 
   if (表达式1) 
       表达式2 
   else 
       表达式3 
   awk '{print ($1>4 ? "high "$1: "low "$1)}' file 


9、awk '$1 * $2 >100 {print $1}' file 显示文件中第一个域匹配101的行（记录）。


10、awk '{$1 == 'Chi' {$3 = 'China'; print}' file 找到匹配行后先将第3个域替换后再显示该行（记录）。 
    awk '{$7 %= 3; print $7}'  file 将第7域被3除，并将余数赋给第7域再打印。


11、awk '/tom/ {wage=$2+$3; printf wage}' file 找到匹配行后为变量wage赋值并打印该变量。


12、awk '/tom/ {count++;}  
         END {print "tom was found "count" times"}' file END表示在所有输入行处理完后进行处理。


13、awk 'gsub(/\$/,"");gsub(/,/,""); cost+=$4; 
         END {print "The total is $" cost>"filename"}'    file gsub函数用空串替换$和,再将结果输出到filename中。 
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


14、awk '{ print FILENAME,$0 }' file1 file2 file3>fileall 把file1、file2、file3的文件内容全部写到fileall中，格式为 
    打印文件并前置文件名。


15、awk ' $1!=previous { close(previous); previous=$1 }    
    {print substr($0,index($0," ") +1)>$1}' fileall 把合并后的文件重新分拆为3个文件。并与原文件一致。


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


19、在awk中调用系统变量必须用单引号，如果是双引号，则表示字符串 
Flag=abcd 
awk '{print '$Flag'}'   结果为abcd 
awk '{print  "$Flag"}'   结果为$Flag

以上转自chinaunix，以下是自己的总结：

求和：

    $awk 'BEGIN{total=0}{total+=$4}END{print total}' a.txt   -----对a.txt文件的第四个域进行求和！

$ awk '/^(no|so)/' test-----打印所有以模式no或so开头的行。

$ awk '/^[ns]/{print $1}' test-----如果记录以n或s开头，就打印这个记录。

$ awk '$1 ~/[0-9][0-9]$/(print $1}' test-----如果第一个域以两个数字结束就打印这个记录。

$ awk '$1 == 100 || $2 < 50' test-----如果第一个或等于100或者第二个域小于50，则打印该行。

$ awk '$1 != 10' test-----如果第一个域不等于10就打印该行。

$ awk '/test/{print $1 + 10}' test-----如果记录包含正则表达式test，则第一个域加10并打印出来。

$ awk '{print ($1 > 5 ? "ok "$1: "error"$1)}' test-----如果第一个域大于5则打印问号后面的表达式值，否则打印冒号后面的表达式值。

$ awk '/^root/,/^mysql/' test----打印以正则表达式root开头的记录到以正则表达式mysql开头的记录范围内的所有记录。如果找到一个新的正则表达式root开头的记 录，则继续打印直到下一个以正则表达式mysql开头的记录为止，或到文件末尾。
