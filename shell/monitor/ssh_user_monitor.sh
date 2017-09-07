

##监控SSH的一个脚本
is_root=`w | awk -F'[ ]' '{print $7}'`
#if [ $is_root >= 0 ]
#   then
#   echo $is_root
#is_root1=`w | awk -F'[ ]' '{print $8}'`
#echo >> 111.log
#is_root1=`cat 111.log`
is_root2=`w | awk -F'[ ]' '{print $9}'`
echo $is_root2 > /tmp/user2.log
#root1=`cat 111.log | awk -F'[ ]' '{print $1}'`
#root2=`cat 222.log | awk -F'[ ]' '{print $1}'`
is_root3=`w | awk -F'[ ]' '{print $1}'`
echo $is_root2 > /tmp/user5.log
echo $is_root3 >> /tmp/user5.log
echo $is_root3 > /tmp/user3.log
diff /tmp/user1.log /tmp/user3.log
if [ $? -eq 0 ]
then 
   echo 222
else
   echo 333
#root2=`cat 222.log | awk -F'[ ]' '{print $2}'`
/bin/mail -s "$is_root test_haha" ppabc@qq.com < /tmp/user5.log
echo $is_root3 > /tmp/user1.log
   exit 1
fi
#fi


#is_root=`w | awk -F'[ ]' '{print $7}'`
#if [ $is_root > 0 ]
#   then
#   echo $is_root
#   exit 1
#fi


