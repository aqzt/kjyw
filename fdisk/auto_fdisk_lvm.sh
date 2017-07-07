#/bin/bash
#########################################
## Linux系统LVM逻辑卷创建过程以及自动化脚本
## http://zhangge.net/5109.html
## email: ge#zhangge.net
## 张戈
## centos 6
#########################################

partition=/data                # 定义最终挂载的名称
vgname=vg                      # 定义逻辑卷组的名称
lvname=lvm                     # 定义逻辑卷的名称
code='b c d e f g h i k j l'   # 根据分区的实际情况修改
 
disk=
for i in $code  
do
fdisk /dev/sd$i << EOF          # 这里自动化完成了所有分区fdisk苦逼的交互步骤
n
p
1
1
 
t
8e
w
EOF
disk="$disk /dev/sd${i}1" # 将所有分区拼起来
done
 
pvcreate $disk
vgcreate $vgname $disk
lvcreate -l 100%VG -n $lvmname $vgname
mkfs.ext4 /dev/$vgname/$lvmname
 
mkdir -p $partition
echo "/dev/$vgname/$lvmname  $partition  ext4 noatime,acl,user_xattr  1 2' >> /dev/fstab
mount -a
df -h