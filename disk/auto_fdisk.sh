#/bin/bash
#########################################
## LINUX自动分区  处理单块磁盘有未分区空间 2016-09-01
## http://www.aqzt.com
## email: ppabc@qq.com
## robert yu
## centos 6
#########################################

count=0
tmp1=/tmp/tmp1.log
tmp2=/tmp/tmp2.log
>$tmp1
>$tmp2
fstab_file=/etc/fstab

#check lock file ,one time only let the script run one time 
LOCKfile=/tmp/.$(basename $0)
if [ -f "$LOCKfile" ]
then
  echo -e "\033[1;40;31mThe script is already exist,please next time to run this script.\033[0m"
  exit
else
  echo -e "\033[40;32mStep 1.No lock file,begin to create lock file and continue.\033[40;37m"
  touch $LOCKfile
fi

#check user
if [ $(id -u) != "0" ]
then
  echo -e "\033[1;40;31mError: You must be root to run this script, please use root to install this script.\033[0m"
  rm -rf $LOCKfile
  exit 1
fi

#check disk partition
check_disk()
{
  >$LOCKfile
  device_list=$(fdisk -l|grep "dev"|grep "sd"|awk -F [：] '{print $1}' |awk '{print $2}' |awk -F: '{print $1}' |head -n 1)
  fdisk -l|grep "sda" |grep "dev" |grep Linux |grep "sd"|awk '{print $1}' >$tmp1
}

#check os
check_os()
{
  os_release=$(grep "CentOS" /etc/issue 2>/dev/null)
  os_release_2=$(grep "CentOS" /etc/redhat-release 2>/dev/null)
  if [ "$os_release" ] && [ "$os_release_2" ]
  then
      os_release=CentOS
      modify_env
  fi
}

#install ext4
modify_env()
{
  #yum install e4fsprogs parted -y
  #modprobe ext4
  echo ext4
}

#fdisk ,formating and create the file system
fdisk_fun()
{
fdisk -S 56 $1 << EOF
n
e


n


p


wq

EOF

sleep 5
#mkfs.ext4 ${1}1
}

#config /etc/fstab and mount device
main()
{

fdisk_fun $device_list

fdisk -l|grep "sda" |grep "dev" |grep Linux |grep "sd"|awk '{print $1}' >$tmp2
#partprobe
for i in `grep -F -v -f $tmp1 $tmp2 | sort | uniq`
do
  
partx -a $device_list
partx -a $i $device_list
mkfs -t ext4 $i
if  [ ! -d /data ];then 
mkdir -p /data
mount  $i  /data
echo "$i  /data                                                  ext4    defaults        1 2" >>$fstab_file
else
   if  [ ! -d /data1 ];then 
   mkdir -p /data1
   mount  $i  /data1
   echo "$i  /data1                                                  ext4    defaults        1 2" >>$fstab_file
   fi 
fi 

done

}

#=========start script===========
echo -e "\033[40;32mStep 2.Begin to check free disk.\033[40;37m"
check_os
check_disk
main
df -h

