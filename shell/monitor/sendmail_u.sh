#!/bin/bash
echo "1) start mail"
echo "2) stop mail"
echo "3) mailq and ls"
echo "input : "
read num
echo "the input data is $num"

case $num in
1) 
service sendmail start
service dovecot start
service saslauthd start
echo ok ;;

2) 
service sendmail stop
service dovecot stop
service saslauthd stop
rm -rf /var/spool/mqueue/*
echo ok ;;

3) echo "3"
ls /var/spool/mqueue/*
mailq
   echo "ok";;

*)
echo "not correct input";;

esac