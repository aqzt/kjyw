#/bin/bash
#########################################
#Function:    auto fdisk
#Usage:       bash auto_fdisk.sh
#Author:      Customer service department
#Company:     Alibaba Cloud Computing
#Version:     4.0
#########################################

count=0
tmp1=/tmp/.tmp1
tmp2=/tmp/.tmp2
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
  device_list=$(fdisk -l|grep "Disk"|grep "/dev"|awk '{print $2}'|awk -F: '{print $1}'|grep "vd")
  for i in `echo $device_list`
  do
    device_count=$(fdisk -l $i|grep "$i"|awk '{print $2}'|awk -F: '{print $1}'|wc -l)
    echo 
    if [ $device_count -lt 2 ]
    then
      now_mount=$(df -h)
      if echo $now_mount|grep -w "$i" >/dev/null 2>&1
      then
        echo -e "\033[40;32mThe $i disk is mounted.\033[40;37m"
      else
        echo $i >>$LOCKfile
        echo "You have a free disk,Now will fdisk it and mount it."
      fi
    fi
  done
  disk_list=$(cat $LOCKfile)
  if [ "X$disk_list" == "X" ]
  then
    echo -e "\033[1;40;31mNo free disk need to be fdisk.Exit script.\033[0m"
    rm -rf $LOCKfile
    exit 0
  else
    echo -e "\033[40;32mThis system have free disk :\033[40;37m"
    for i in `echo $disk_list`
    do
      echo "$i"
      count=$((count+1))
    done
  fi
}

#check os
check_os()
{
  os_release=$(grep "Aliyun Linux release" /etc/issue 2>/dev/null)
  os_release_2=$(grep "Aliyun Linux release" /etc/aliyun-release 2>/dev/null)
  if [ "$os_release" ] && [ "$os_release_2" ]
  then
    if echo "$os_release"|grep "release 5" >/dev/null 2>&1
    then
      os_release=aliyun5
      modify_env
     fi
  fi
}

#install ext4
modify_env()
{
  modprobe ext4
  yum install e4fsprogs -y
}

#fdisk ,formating and create the file system
fdisk_fun()
{
fdisk -S 56 $1 << EOF
n
p
1


wq
EOF

sleep 5
mkfs.ext4 ${1}1
}

#make directory
make_dir()
{
  echo -e "\033[40;32mStep 4.Begin to make directory\033[40;37m"
  now_dir_count=$(ls /|grep "alidata*"|awk -F "data" '{print $2}'|sort -n|tail -1)
  if [ "X$now_dir_count" ==  "X" ]
  then
    for j in `seq $count`
    do
      echo "/data$j" >>$tmp1
      mkdir /data$j
    done
  else
    for j in `seq $count`
    do
      k=$((now_dir_count+j))
      echo "/data$k" >>$tmp1
      mkdir /data$k
    done
  fi
 }

#config /etc/fstab and mount device
main()
{
  for i in `echo $disk_list`
  do
    echo -e "\033[40;32mStep 3.Begin to fdisk free disk.\033[40;37m"
    fdisk_fun $i
    echo "${i}1" >>$tmp2
  done
  make_dir
  >$LOCKfile
  paste $tmp2 $tmp1 >$LOCKfile
  echo -e "\033[40;32mStep 5.Begin to write configuration to /etc/fstab and mount device.\033[40;37m"
  while read a b
  do
    if grep -v ^# $fstab_file|grep ${a} >/dev/null
    then
      sed -i "s=${a}*=#&=" $fstab_file
    fi
    echo "${a}             $b                 ext4    defaults        0 0" >>$fstab_file
  done <$LOCKfile
  mount -a
}

#=========start script===========
echo -e "\033[40;32mStep 2.Begin to check free disk.\033[40;37m"
check_os
check_disk
main
df -h
rm -rf $LOCKfile $tmp1 $tmp2
