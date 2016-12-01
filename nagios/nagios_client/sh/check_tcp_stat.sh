#!/bin/bash

#nagios exit code
STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3

#help
help () {
	local command=`basename $0`
        echo "NAME
	${command} -- check network status
SYNOPSIS
	${command} [OPTION]
DESCRIPTION
	-H IP ADDRESS
	-p LOCAL PORT
	-S [TIME_WAIT|FIN_WAIT|ESTABLISHED|CLOSING|SYN_SEND|TIMED_WAIT|LISTEN]
	-w warning
	-c critical
USAGE:
Total connections:
	$0 -w 100 -c 200
Port:
	$0 -p 8819 -w 100 -c 200
Host and Port:
	$0 -H 192.168.0.6 -p 8819 -w 100 -c 200
Status:
	$0 -H 192.168.0.6 -p 8819 -S ESTABLISHED -w 100 -c 200" 1>&2
        exit ${STATE_WARNING}
}

check_num () {
	local num_str="$1"
	echo ${num_str}|grep -E '^[0-9]+$' >/dev/null 2>&1 || local stat='not a positive integers!'
	if [ "${stat}" = 'not a positive integers!' ];then
   		echo "${num_str} ${stat}" 1>&2
		exit ${STATE_WARNING}
	else
		local num_int=`echo ${num_str}*1|bc`
		if [ ${num_int} -lt 0 ];then
			echo "${num_int} must be greater than 0!" 1>&2
			exit ${STATE_WARNING}
		fi
	fi
}

check_ip () {
	local ip_str="$1"
	echo "${ip_str}"|grep -P '^\d{1,3}(\.\d{1,3}){3}$' >/dev/null 2>&1 || local stat='not a ip!'
	if [ "${ip_stat}" = 'not a ip!' ];then
        echo "${ip_str} ${stat}" 1>&2
		exit ${STATE_WARNING}
    fi
}

check_state () {
	local stat_str="$1"
	if [ -n "${stat_str}" ];then
		case "${stat_str}" in
				TIME_WAIT|FIN_WAIT|ESTABLISHED|CLOSING|SYN_SEND|TIMED_WAIT)
					cmd="netstat -nt|grep ${stat_str}"
                ;;
				LISTEN)
					cmd="netstat -ntl"
				;;
                *)
					echo "This script only support [TIME_WAIT|FIN_WAIT|ESTABLISHED|CLOSING|SYN_SEND|TIMED_WAIT]" 1>&2
					exit ${STATE_WARNING}
                ;;
		esac
	fi
}

logging () {
local now_date=`date -d now +"%F %T"`
local log_path='/var/log/tcp'
local log_name=`date -d "now" +"%F"`

local uid=`id -u`
if [ "${uid}" == '0' ];then
	test -d ${log_path} || mkdir -p ${log_path}/
	chown nagios.nagios -R ${log_path}
fi

log="${log_path}/tcp_stat_${log_name}.log"
echo "${now_date} ${info}"|sed 's/;//g' >> ${log} 
test -f ${log} && chown nagios.nagios ${log}
}

message () {
	local stat="$1"
	echo "TCP status is ${stat} - ${info}|Total_connections=${total_connections_int};${warning};${critical};${min};${max}"
}

#input
while getopts w:c:p:H:S:l opt
do
        case "$opt" in
		w) 
			warning=$OPTARG
			check_num "${warning}"
		;;
        c) 
			critical=$OPTARG
			check_num "${critical}"
		;;
        p) 
			port="$OPTARG"
			check_num "${port}"
		;;
        H) 
			ip="$OPTARG"
			check_ip "${ip}"
		;;
		S) 
			state="$OPTARG"
			check_state "${state}"
		;;
		l)
			log_status='on'
		;;
        *) help;;
        esac
done
shift $[ $OPTIND - 1 ]

#[ $# -gt 0 -o -z "${warning}" -o -z "${critical}" ] && help
[ $# -gt 0 -o -z "${warning}" ] && help

if [ -n "${warning}" -a -n "${critical}" ];then
	if [ ${warning} -ge ${critical} ];then
		echo "-w ${warning} must lower than -c ${critical}!" 1>&2
		exit ${STATE_UNKNOWN}
	fi
fi

if [ -n "${warning}" -a -z "${critical}" ];then
	if [ "${warning}" == "0" ];then
		critical="${warning}"
	else
		echo "Critical can not be empty!" 1>&2
		exit ${STATE_UNKNOWN}
	fi
fi

[ -z "${state}" ] && netstat_cmd="netstat -nt" || netstat_cmd="${cmd}"
[ -z "${ip}" -a -z "${port}" ] && run_cmd="${netstat_cmd}"
[ -n "${ip}" -a -z "${port}" ] && run_cmd="${netstat_cmd}|grep \"${ip}:\"" 
[ -n "${port}" -a -z "${ip}" ] && run_cmd="${netstat_cmd}|grep -P \":${port}\s\""
[ -n "${port}" -a -n "${ip}" ] && run_cmd="${netstat_cmd}|grep -P \"${ip}:${port}\s\"" 

info=`eval "${run_cmd}"|\
awk 'BEGIN{OFS=":";ORS="; "}/^tcp/{stats[$(NF)]+=1;sum++}END{print "Total",sum;for (stat in stats) {print stat,stats[stat]}}'`

echo "${info}"|grep -E '[0-9]' >/dev/null 2>&1 || info="Total:0"

min=0
max=4096
total_connections_str=`echo "${info}"|grep -oP "Total:\d+"|awk -F':' '{print $2}'`
total_connections_int=`echo "${total_connections_str}*1"|bc`
echo "${total_connections_int}"|grep -E '^[0-9]+$' >/dev/null 2>&1 ||\
eval "echo ${total_connections_int} not a number!;exit ${STATE_UNKNOWN}"

[ "${log_status}" == 'on' ] && logging

if [ "${warning}" == "0" ];then
	if [ ${total_connections_int} -eq 0 ];then
		message "Warning"
		exit ${STATE_WARNING}
	else
		message "OK"
		exit ${STATE_OK}
	fi
fi

[ ${total_connections_int} -lt ${warning} ] && message "OK" && exit ${STATE_OK}
[ ${total_connections_int} -ge ${critical} ] && message "Critical" && exit ${STATE_CRITICAL}
[ ${total_connections_int} -ge ${warning} ] && message "Warning" && exit ${STATE_WARNING}
