#!/bin/bash
## gitlab_rpm 2016-05-16
## http://www.aqzt.com
##email: ppabc@qq.com
##robert yu
##centos 6和centos 7
##运维就是踩坑，踩坑的最高境界就是：踩遍所有的坑，让别人无坑可踩！



#find . {-atime/-ctime/-mtime/-amin/-cmin/-mmin} [-/+]num
#atime：访问时间（access time），指的是文件最后被读取的时间，可以使用touch命令更改为当前时间；
#ctime：变更时间（change time），指的是文件本身最后被变更的时间，变更动作可以使chmod、chgrp、mv等等；
#mtime：修改时间（modify time），指的是文件内容最后被修改的时间，修改动作可以使echo重定向、vi等等；

#第一个参数，.，代表当前目录，如果是其他目录，可以输入绝对目录和相对目录位置；
#第二个参数分两部分，前面字母a、c、m分别代表访问、变更、修改，后面time为日期，min为分钟，注意只能以这两个作为单位；
#第三个参数为量，其中不带符号表示符合该数量的，带-表示符合该数量以后的，带+表示符合该数量以前的。

#找/data目录下一小时之前文件删除
find /data -mmin +60 -exec rm -f {} \;

#在当前目录下查找以april开始的文件
find   -name april*
#在当前目录下查找以april开始的文件，并把结果输出到file中
find   -name   april*   fprint file       
#查找以ap或may开头的文件 
find   -name ap* -o -name may*   
#在/mnt下查找名称为tom.txt且文件系统类型为vfat的文件
find   /mnt   -name tom.txt   -ftype vfat   
#在/mnt下查找名称为tom.txt且文件系统类型不为vfat的文件
find   /mnt   -name t.txt ! -ftype vfat   
#在/tmp下查找名为wa开头且类型为符号链接的文件
find   /tmp   -name wa* -type l  
#在/home下查最近两天内改动过的文件          
find   /home   -mtime   -2           
#查1天之内被存取过的文件      
find /home    -atime -1       
#在/home下查60分钟前改动过的文件           
find /home -mmin    +60       
#查最近30分钟前被存取过的文件           
find /home   -amin   +30              
#在/home下查更新时间比tmp.txt近的文件或目录    
find /home   -newer   tmp.txt             
#在/home下查存取时间比tmp.txt近的文件或目录
find /home   -anewer   tmp.txt       
#列出文件或目录被改动过之后，在2日内被存取过的文件或目录     
find   /home   -used   -2          
#列出/home目录内属于用户cnscn的文件或目录        
find   /home   -user cnscn           
#列出/home目录内用户的识别码大于501的文件或目录     
find   /home   -uid   +501    
#列出/home内组为cnscn的文件或目录              
find   /home   -group   cnscn   
#列出/home内组id为501的文件或目录           
find   /home   -gid 501          
#列出/home内不属于本地用户的文件或目录        
find   /home   -nouser                 
#列出/home内不属于本地组的文件或目录   
find   /home   -nogroup                  
#列出/home内的tmp.txt 查时深度最多为3层 
find   /home    -name tmp.txt    -maxdepth   4   
#从第2层开始查
find   /home   -name tmp.txt   -mindepth   3   
#查找大小为0的文件或空目录
find   /home   -empty     
#查大于512k的文件                      
find   /home   -size   +512k    
#查小于512k的文件
find   /home   -size   -512k          
#查硬连接数大于2的文件或目录     
find   /home   -links   +2       
#查权限为700的文件或目录         
find   /home   -perm   0700       
#查/tmp 的tmp.txt并查看
find   /tmp   -name tmp.txt   -exec cat {} \;
#查/tmp 的tmp.txt并删除
find   /tmp   -name   tmp.txt   -ok   rm {} \;
# 查找在系统中最后10分钟访问的文件
find    /   -amin    -10     
# 查找在系统中最后48小时访问的文件
find    /   -atime   -2        
# 查找在系统中为空的文件或者文件夹
find    /   -empty             
# 查找在系统中属于 groupcat的文件
find    /   -group   cat       
# 查找在系统中最后5分钟里修改过的文件 
find    /   -mmin   -5         
#查找在系统中最后24小时里修改过的文件
find    /   -mtime   -1       
#查找在系统中属于作废用户的文件
find    /   -nouser         
#查找在系统中属于FRED这个用户的文件  
find    /   -user    fred     
#查当前目录下的所有普通文件
find . -type f -exec ls -l {} \; 
##在/logs目录中查找更改时间在5日以前的文件并删除它们：
find logs -type f -mtime +5 -exec   -ok   rm {} \;


##匹配字符串，找出存在字符串文件
find /data -name "*.php" -type f -print0|xargs -0 egrep "(phpspy|c99sh|milw0rm|eval\(base64_decode|spider_bc)"|awk -F: '{print $1}'|sort|uniq
find /data -name "*.php" -type f -print0|xargs -0 egrep "aaa"|awk -F: '{print $1}'|sort|uniq
find . -name "*.php" -type f -print0| xargs -0 egrep  "aaa|bbb"| egrep "aaa"

##cd  /var/cache/yum找*.rpm移动到一个文件夹
find  . -name  "*.rpm" -exec cp {} /root/111 \;

##找到*.log日志全部删除
find . -name *.log | xargs rm
find . -name *.rpm | xargs rm
find /data/file1 -name .svn -print0 | xargs -0 rm -r -f
find /data/file1 -name .git -print0 | xargs -0 rm -r -f

#删除5天之前的日志
find /data/nginx/log/ -ctime +5 -exec rm -f {} \;
find /data/logs -ctime +5 -exec rm -f {} \;
find /data/logs -name "localhost_access_log*.txt" -type f -mtime +5 -print -exec rm -f {} \;
find /data/zookeeper/logs -name "log.*" -type f -mtime +5 -print -exec rm -f {} \;

##删除目录下所有的 .svn 隐藏子目录
find . -name .svn -print0 | xargs -0 rm -r -f
find /data/file1 -name .svn -print0 | xargs -0 rm -r -f
find /data/file1 -name .git -print0 | xargs -0 rm -r -f
find . -name .svn -print0 | xargs -0 rm -r -f
find . -name .git -print0 | xargs -0 rm -r -f


##找出 n 天前的文件
find /temp/ -type f -mtime +n -print

##注：/temp/ 指出寻找/temp/目录下的文件
##-type f 指出找系统普通文件，不包含目录文件
##-mtime +n 指出找 n*24 小时前的文件
##-print 将找出的文件打印出来

##如：找出 7 天前的文件
find /temp/ -type f -mtime +7 -print
##找出 3 天前的文件
find /temp/ -type f -mtime +3 -print

##找出并删除 7 天前的文件
find /temp/ -type f -mtime +7 -print -exec rm -f {} \;
find /temp/ "ut*.log" -type f -mtime +7 -print -exec rm -f {} \;

##注：-exec 指出要执行后面的系统命令
##rm -f 删除找出的文件
##{} 只有该符号能跟在命令后面
##\ 结束符

##也可以使用 xargs 代替 -exec
find /temp/ -type f -mtime +7 -print | xargs rm -f

##find命令用途举例：
##如：
##查找/var下最大的前10个文件：
find /var -type f -ls | sort -k 7 -r -n | head -10

##查找/var/log/下大于5GB的文件：
find /var/log/ -type f -size +5120M -exec ls -lh {} \;

##找出今天的所有文件并将它们拷贝到另一个目录：
find /home/me/files -ctime 0 -print -exec cp {} /mnt/backup/{} \;

##找出所有一周前的临时文件并删除：
find /temp/ -mtime +7-type f | xargs /bin/rm -f

##查找所有的mp3文件，并修改所有的大写字母为小写字母：
find /home/me/music/ -type f -name *.mp3 -exec rename ‘y/[A-Z]/[a-z]/’ ‘{}’ \;


