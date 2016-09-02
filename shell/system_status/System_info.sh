#!/bin/bash
disk_info ()
{
   echo "======================disk info========================"
   df -ThP|column -t
}

cpu_info ()
{
   echo "=======================cpu info========================"
   echo "cpu processor is $(grep "processor" /proc/cpuinfo |wc -l)"
   echo "cpu mode name is $(grep "model name" /proc/cpuinfo |uniq|awk '{print $4,$5,$6,$7,$8,$9}')"
   grep "cpu MHz" /proc/cpuinfo |uniq |awk '{print $1,$2":"$4}'
   awk '/cache size/ {print $1,$2":"$4$5}' /proc/cpuinfo |uniq
}

mem_info ()
{
   echo "=====================memory info========================"
   MemTotal=$(awk '/MemTotal/ {print $2}' /proc/meminfo)
   MemFree=$(awk '/MemFree/ {print $2}' /proc/meminfo)
   Buffers=$(awk '/^Buffers:/ {print $2}' /proc/meminfo)
   Cached=$(awk '/^Cached:/ {print $2}' /proc/meminfo)
   FreeMem=$(($MemFree/1024+$Buffers/1024+$Cached/1024))
   UsedMem=$(($MemTotal/1024-$FreeMem))
   echo "Total memory is $(($MemTotal/1024)) MB"
   echo "Free  memory is ${FreeMem} MB"
   echo "Used  memory is ${UsedMem} MB"
}

load_info ()
{
   echo "=====================load info=========================="
   Load1=$(awk  '{print $1}' /proc/loadavg)
   Load5=$(awk  '{print $2}' /proc/loadavg)
   Load10=$(awk '{print $3}' /proc/loadavg)
   echo "Load in 1  min is $Load1"
   echo "Load in 5  min is $Load5"
   echo "Load in 10 min is $Load10"
}

network_info ()
{
   echo "=====================network info======================="
   network=$(ifconfig |grep  "inet addr" |grep -v "127.0.0.1" |awk '{print $2}'|sed "s/addr://g")
   echo "network eth0 IP is $network"
}

network_card_info ()
{
   echo "=====================network_card_info==================="
   card=$(ip a|awk -F "inet|/"  '/inet.*brd/ {print $2}')
   echo "Network card  is $card"
}



disk_info 
cpu_info
mem_info 
load_info   
network_info
network_card_info
