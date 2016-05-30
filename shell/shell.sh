#!/bin/bash
##   2016-05-30
## http://www.aqzt.com
##email: ppabc@qq.com
##robert yu
##centos 6和centos 7

利用wc命令统计文件行，单词数，字符数，利用sort排序和去重，再结合uniq可以进行词频统计。比如：

$ cat file.txt
aqztcom
aqztcom-talk
aqztcom-yun
aqztcom
aqztcom-shuo
$ sort file.txt | uniq -c | sort -nr | head -5
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
