#!/bin/bash
## shell常用命令  2016-05-30
## http://www.aqzt.com
## email: ppabc@qq.com
## robert yu
## centos 6和centos 7

##下载脚本并执行
wget -q -O https://raw.githubusercontent.com/aqzt/kjyw/master/redis/install.sh | sh
curl -s https://raw.githubusercontent.com/aqzt/kjyw/master/redis/install.sh | sh
curl -fsSL https://raw.githubusercontent.com/aqzt/kjyw/master/redis/install.sh  | sh
##传参数
curl -s https://raw.githubusercontent.com/aqzt/kjyw/master/redis/redis_port.sh  | sh -s  start 8001 8009

##内存强制释放命令，最好不要在生产环境使用，生产环境需先下线服务，再使用
echo 3 > /proc/sys/vm/drop_caches

##sync 命令将所有未写的系统缓冲区写到磁盘中，再强制释放内存
sync && echo 3 > /proc/sys/vm/drop_caches

##Mutt 发送测试邮件
echo "邮件内容123456" | mutt -s “邮件标题测试邮件” -a /home/test.txt aaa@test.com
echo "mail test 123"  | mail -s "mail_test"  aaa@test.com

##生成16位随机密码
openssl rand -base64 12

##生成32位随机密码
openssl rand -base64 24

批量创建文件夹
mkdir 60{00..19}

#利用wc命令统计文件行，单词数，字符数，利用sort排序和去重，再结合uniq可以进行词频统计。比如：
cat file.txt
aqztcom
aqztcom-talk
aqztcom-yun
aqztcom
aqztcom-shuo
sort file.txt | uniq -c | sort -nr | head -5
   2 aqztcom
   1 aqztcom-shuo
   1 aqztcom-talk
   1 aqztcom-yun

gzip/tar：压缩/解压
cat/zcat：文件查看
less/more：文件查看，支持gz压缩格式直接查看
head/tail：查看文件前/后10行
wc：统计行数、单词数、字符数
du -h -c -s：查看空间占用

awk：命令行下的数据库操作工具
join/cut/paste：关联文件/切分字段/合并文件
fgrep/grep/egrep：全局正则表达式查找
find：查找文件，并且对查找结果批量化执行任务
sed：流编辑器，批量修改、替换文件
split：对大文件进行切分处理，按多少行一个文件，或者多少字节一个文件
rename：批量重命名(Ubuntu上带的perl脚本，其它系统需要安装)，使用-n命令进行测试

#如果想临时计时跑满下CPU，一个进程跑满一个核。可以用如下命令：
timeout 600 bash -c "while [ 1 ];do echo 'a' > /dev/null; done"

#查nagios告警Warning太多IP,并排序重复次数
cat nagios-09-18-2016-00.log  |grep mail  |grep Warning |grep em |grep Traffic > 1.log
cat nagios-09-18-2016-00.log  |grep mail  |grep Warning |grep em |grep Traffic | awk -F '[;]' '{print $2}' >2.log
sort 2.log | uniq -c | sort -n > 3.log

#查nagios告警Critical太多IP,并排序重复次数
cat nagios-09-18-2016-00.log  |grep mail  |grep Critical |grep em |grep Traffic > 1.log
cat nagios-09-18-2016-00.log  |grep mail  |grep Critical |grep em |grep Traffic | awk -F '[;]' '{print $2}' >2.log
sort 2.log | uniq -c | sort -n > 3.log

#查nagios全部告警太多IP,并排序重复次数
cat nagios-09-18-2016-00.log  |grep mail  > 1.log
cat nagios-09-18-2016-00.log  |grep mail  | awk -F '[;]' '{print $2}' >2.log
sort 2.log | uniq -c | sort -n > 3.log

#查日志请求量变多，排序
awk -F'`;' '{print $12}' web_proxy_access_data_nginx.log | sort | uniq -c | sort -rn
awk -F'`;' '{print $12}' web_proxy_access_data_nginx.log | sort | uniq -c | sort -rn | head -n 10

#查日志域名查看接口请求情况
awk -F'`;' '{print $7}' data_nginx.log | awk -F'?' '{print$1}' |  sort| uniq -c | sort -n -k 1 -r | head -n 10

# 解压缩日志
$ gzip -d a.gz
$ tar zcvf/jcvf one.tar.bz2 one
# 直接查看压缩日志
$ less a.gz  
# 无需先解压

# 查询字符串，并显示匹配行的前3行和后3行内容
fgrep 'yunjie-talk' -A 3 -B 3 log.txt
# 在当前目前(及子目录)下，所有的log文件中搜索字符串hacked by:
$ find . -name "*.log" | xargs fgrep "hacked by"

##fgrep, grep, egrep的一些区别：

fgrep按字符串的本来意思完全匹配，里面的正则元字符当成普通字符解析， 如： fgrep “1.2.3.4″ 则只匹配ip地址： 1.2.3.4, 其中的.不会匹配任意字符。fgrep当然会比grep快多了。写起来又简单，不用转义。
grep只使用普通的一些正则，egrep或者grep -E使用扩展的正则，如

egrep "one|two", 匹配one或者two
grep -E -v ".jpg|.png|.gif|.css|.js" log.txt |wc -l

date：命令行时间操作函数
sort/uniq：排序、去重、统计
comm：对两个排序文件进行按行比较（共同行、只出现在左边文件、只出现在右边文件）
diff：逐字符比较文件的异同，配合cdiff，类似于github的显示效果
curl/w3m/httpie：命令行下进行网络请求
iconv：文件编码转换，如：iconv -f GB2312 -t UTF8 1.csv > 2.csv
seq：产生连续的序列，配合for循环使用

$ date -d today +%Y%m%d
20160320
$ date -d yesterday +%Y%m%d
20160319

# 排序两个文件
$ sort a.txt > a.txt.sort
$ sort b.txt > b.txt.sort
# 求只出现在c.sh中的内容
$ comm -2 -3 a.txt.sort b.txt.sort

if条件判断：

if [ -d ${base_d} ];
    then mkdir -p ${base_d};
fi

while循环：

while
do
    do_something;
done

for循环（用得很多）：

for x in *.log.gz;
do
    gzip -d ${x};
done

生成过去8天的日期序列：

$for num in `seq 8 -1 1`;do dd=`date --date="${num} day ago" +%Y%m%d`;echo ${dd};done
20160312
20160313
20160314
20160315
20160316
20160317
20160318
20160319

有目录和文件如下：

20160320 目录
    10.1.0.1_20160320*.log.gz   目录
        201603200000.log.gz          文件
        201603200010.log.gz          文件
    10.1.0.2_20160320*.log.gz   目录
        201603200000.log.gz         文件
        201603200010.log.gz         文件

需求：去掉目录中的*.log.gz，这样很容易让人误解为文件。 rename -n为测试，rename使用和sed相同的语法。

$ for d in 201603??;do echo ${d}; cd ${d}; rename -n 's/*.log.gz//' *.log.gz ; cd ..;done

测试完成后，使用rename不加-n为真正执行重命名操作。


####################################################
把两个空格替换成一个空格，然后一直替换
echo "a b    d" |sed -e 's/  \+/ /g'

如果你闲邮件提醒烦，可以这么干

grep "unset MAILCHECK" /etc/profile
if [ $? -ne 0 ]; then
    sed -i "/unset MAILCHECK/d" /etc/profile
    echo "unset MAILCHECK"  >> /etc/profile
fi

grep -v "^;" /etc/php/php.ini
cat /etc/php/php.ini |grep -v "^;"
egrep -v "^;|^$" /etc/php/php.ini

BM.BM_PAYMENT.AAAfpLACIAAATeGAAK
BM.BM_PAYMENT.AAAfpLACIAAATeGAAL
  awk -F . '{print $0$1}' file
BM.BM_PAYMENT  取这两个  AWK是这样写吗

echo "BM.BM_PAYMENT.AAAfpLACIAAATeGAAK"|awk '{FS=".";OFS=".";print $1,$2}'
BM.BM_PAYMENT
echo "BM.BM_PAYMENT.AAAfpLACIAAATeGAAK"|awk -F'.' '{printf("%s.%s\n",$1,$2)}'   
BM.BM_PAYMENT
两种方法，随便哪个都行echo "BM.BM_PAYMENT.AAAfpLACIAAATeGAAK"|cut -d '.' -f 1,2                    
BM.BM_PAYMENT


useradd
#!/bin/bash
echo "please user"
read name
echo "please num"
read num
n=1
for ((n=1;n<$num;n++))
#while [ $n -le $num ]
do
   echo $name$n
/usr/sbin/useradd $name$n
echo 123123 | /usr/bin/passwd --stdin $name$n
#   n=`expr $n + 1`
done


n=$1
/bin/grep $n /etc/group
if [ $? -eq 0 ]
then
     echo aaa
else
   /usr/sbin/groupadd $n
fi



group2.txt
adminuser dbuser updatauser
dbuser updatauser
updatauser wheel



awk '{print $2","}' user.list > group2.txt
#echo "fenkai:"
sed -i 's/,/ /g' group2.txt
groupid=`cat group2.txt`
for A in $groupid
do
#echo $A
n=$A
       /bin/grep $n /etc/group
       if [ $? -eq 0 ]
       then
            echo $n exists
       else
          /usr/sbin/groupadd $n
       fi

done
#awk -F, '{print $2}' group2.txt



要替代当前目录下所有Makefile中-Werror为‘’

find ./ -type f -name Makefile | xargs perl -pi -e `s|-Werror| |g` 


#!/bin/bash
for AAA in `ls ${DIR}`

do
  
sed -i 's/-Werror//g' $AAA
done

文件夹各自打成一个以文件名的生成一个tar.gz的包
http://bbs.linuxtone.org/thread-10250-1-1.html

写个for就行了
for a in 2011*;do
tar zcvf $a $a.tar.gz
done


ls | awk '{ print "tar zcvf "$0".tgz " $0|"/bin/bash" }' 


