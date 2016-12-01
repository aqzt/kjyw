#!/bin/bash

#set nagios status
STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3

usage (){
        echo -en "Usage: $0 -d [ eth|bond ]\nFor example:\t$0 -d bond0 -w 100[B|K|M|G] -c 200[B|K|M|G]\n" 1>&2
        exit ${STATE_WARNING}
}

check_input () {
local str="$1"
echo "${str}"|grep -E '[0-9]+[b|B|k|K|m|M|g|G]$' >/dev/null 2>&1 ||\
eval "echo ${str} is wrong!;usage"
}

replace_str () {
local str="$1"
output=`echo "${str}"|sed -r 's/[k|K]/*1024/;s/[m|M]/*1024*1024/;s/[g|G]/*1024*1024*1024/'`
echo ${output}
}

while getopts w:c:d: opt
do
        case "$opt" in
		w)
			check_input "$OPTARG"
			warning_str=`replace_str "$OPTARG"`
			warning=`echo "${warning_str}"|bc`
		;;
		c)      
			check_input "$OPTARG"
			critical_str=`replace_str "$OPTARG"`
			critical=`echo "${critical_str}"|bc`
		;;
        d)
			dev_id="$OPTARG"
		;;
        *)
			usage
		;;
        esac
done

shift $[ $OPTIND - 1 ]

if [ -z "${dev_id}" -o -z "${warning}" -o -z "${critical}" ];then
        usage
fi

source_file='/proc/net/dev'
if [ ! -f "${source_file}" ];then
                echo "${source_file} not exsit!" 1>&2
                exit ${STATE_WARNING}
fi

grep "${dev_id}" ${source_file} >/dev/null 2>&1 || dev_stat='not found'
if [ "${dev_stat}" = 'not found' ];then
                echo "${dev_id} ${dev_stat}!" 1>&2
                usage
fi

time_now=`date -d now +"%F %T"`
nagios_path='/usr/local/nagios/libexec'
test -d ${nagios_path} || mkdir -p ${nagios_path} && mark="${nagios_path}/net_traffic.${dev_id}"
search_dev=`awk -F':' '/'${dev_id}'/{print $2}' /proc/net/dev|sed -r 's/^[ ]+//'`
info=`echo "${search_dev}"|awk -v date="${time_now}"  'BEGIN{OFS=";"}{print "TIME=\""date"\"","RX="$1,"TX="$9,"DEV='${dev_id}'"}'`

#debug
#eval "${info}"
#echo $info 
#echo $TIME $RX $TX && exit

marking () {
        echo "$info" > ${mark} || exit ${STATE_WARNING}
        chown nagios.nagios ${mark}
}

if [ ! -f "${mark}" ];then
                marking
                echo "This script is First run! ${info}"
                exit ${STATE_OK}
else
                old_info=`cat ${mark}`
                eval "${old_info}"
                OLD_TIME="${TIME}";OLD_RX=${RX};OLD_TX=${TX}
                if [ -z "${OLD_RX}" -o -z "${OLD_TX}" ];then
                        echo "Data Error: ${old_info}" 1>&2
                        marking
                        exit ${STATE_WARNING}
                fi
fi

if [ -n "${info}" ];then
                eval ${info}
                sec_now=`date -d "${TIME}" +"%s"`
                sec_old=`date -d "${OLD_TIME}" +"%s"`
                sec=`echo "${sec_now}-${sec_old}"|bc|sed 's/-//'`
                rx=`echo "(${RX}-${OLD_RX})/${sec}"|bc|sed 's/-//'`
                tx=`echo "(${TX}-${OLD_TX})/${sec}"|bc|sed 's/-//'`
                marking
#debug
#               echo $sec $rx $tx
else
                echo "Can not read ${source_file}" 1>&2
                exit ${STATE_WARNING}
fi

human_read () {
local number="$1"
if [ `echo "(${number}-1073741824) > 0"|bc` -eq 1 ];then
        output="`echo "scale=2;${number}/1024/1024/1024"|bc` GB/s"
elif [ `echo "(${number}-1048576) > 0"|bc` -eq 1 ];then
        output="`echo "scale=2;${number}/1024/1024"|bc` MB/s"
elif [ `echo "(${number}-1024) > 0"|bc` -eq 1 ];then
        output="`echo "scale=2;${number}/1024"|bc` KB/s"
else
        output="${number} B/s"
fi
echo "${output}"
}

rx_human_read=`human_read "${rx}"`
tx_human_read=`human_read "${tx}"`

message () {
    local stat="$1"
    echo "${DEV} Traffic is ${stat} - In: ${rx_human_read} Out: ${tx_human_read} interval: ${sec}s |in=${rx};${warning};${critical};${min};${max} out=${tx};${warning};${critical};${min};${max}"
}

#pnp4nagios setting
min=0
max=1073741824

total_int=`echo "${rx}+${tx}"|bc`

[ `echo "(${total_int}-${warning}) < 0"|bc` -eq 1 ] && message "OK" && exit ${STATE_OK}
[ `echo "(${total_int}-${critical}) >= 0"|bc` -eq 1 ] && message "Critical" && exit ${STATE_CRITICAL}
[ `echo "(${total_int}-${warning}) >= 0"|bc` -eq 1 ] && message "Warning" && exit ${STATE_WARNING}
