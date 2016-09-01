#!/bin/sh
os=`uname`
total=0
name=0
id=0
mem=0
vcpu=0
state=0
time=0
#temp=`xm list`
if [ "$os" = "linux" ] || [ "$os" = "Linux" ]
then
	name=`xm list|sed -n '2p'|awk '{print $1}'`
       id=`xm list|sed -n '2p'|awk '{print $2}'`
       mem=`xm list|sed -n '2p'|awk '{print $3}'`
      vcpu=`xm list|sed -n '2p'|awk '{print $4}'`
     state=`xm list|sed -n '2p'|awk '{print $5}'`
      time=`xm list|sed -n '2p'|awk '{print $6}'`
   
    fi



echo "Xen-1(name)=$name"
echo "Xen-1(id)=$id"
echo "Xen-1(mem)=$mem"
echo "Xen-1(vcpu)=$vcpu"
echo "Xen-1(state)=$state"
echo "Xen-1(time)=$time"
echo "status_text=Xen-1(name):{0},Xen-1(id):{1},Xen-1(mem):{2},Xen-1(vcpu):{3},Xen-1(state):{4},Xen-1(time):{5};;;${name};;;${id};;;${mem};;;${vcpu};;;${state};;;${time}"
exit 0
