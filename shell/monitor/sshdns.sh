#!/bin/bash
# Shell script to monitor running services such as web/http, ssh, mail etc.
# If service fails it will send an Email to ADMIN user
# -------------------------------------------------------------------------
# Copyright (c) 2006 nixCraft project <http://www.cyberciti.biz/fb/>
# This script is licensed under GNU GPL version 2.0 or above
# -------------------------------------------------------------------------
# This script is part of nixCraft shell script collection (NSSC)
# Visit http://bash.cyberciti.biz/ for more information.
# ----------------------------------------------------------------------
# See URL for more info
# http://www.cyberciti.biz/tips/processing-the-delimited-files-using-cut-and-awk.html
# ---------------------------------------------------
# Last updated: Jun - 15 - 2009.
ports="22 53 80 25"

# service names as per above ports
service="SSH DNS WEB MAIL"

#Email id to send alert
ADMINEMAIL="ppabc@qq.com"

#Bin paths, set them according to your Linux distro
NETSTAT=/bin/netstat
MAIL=/bin/mail
LOGGER=/bin/logger
ID=/usr/bin/id

# Red hat usr uncomment
MAIL=/bin/mail
LOGGER=/bin/logger

#Counters, set defaults
c=1
status=""
sendmail=0

# set the following to 1, if you want message in /var/log/messages via a SYSLOG
logtosyslog=0

# Log file used to send an email
LOG="/tmp/services.log.$$"

# log message to screen and a log file
log(){
    echo "$@"
    echo "$@" >> $LOG
}

# log message and stop script
die(){
    echo "$@"
    exit 999
}

# Make sure only root can run it
is_root(){
    local id=$($ID -u)
    [ $id -ne 0 ]  && die "You must be root to run $0."
}
# Look out for all bins and create a log file
init_script(){
    [ ! -x $MAIL ] && die "$MAIL command not found."
    [ ! -x $NETSTAT ] && die "$NETSTAT command not found."
    [ ! -x $LOGGER ] && die "$LOGGER command not found."
    [ ! -x $ID ] && die "$ID command not found."
    is_root
    >$LOG
}

# check for all running services and shoot an email if service is not running
chk_services(){
    log "-------------------------------------------------------------"
    log "Running services status @ $(hostname) [ $(date) ]"
    log "-------------------------------------------------------------"

    # get open ports
    RPORTS=$($NETSTAT -tulpn -A inet | grep -vE '^Active|Proto' | grep 'LISTEN' | awk '{ print $4}' | cut -d: -f2 | sed '/^$/d' | sort  -u)

    # okay let us compare them
    for t in $ports
    do
        sname=$(echo $service | cut -d' ' -f$c)
        echo -en " $sname\t\t\t : "
        echo -en " $sname\t\t\t : " >> $LOG
        for r in $RPORTS
        do
            if [ "$r" == "$t" ]
            then
                status="YES"
                sendmail=1
                break
            fi
        done
        echo -n "$status"
        echo ""
        echo -n "$status" >>$LOG
        echo "" >>$LOG
        # Log to a syslog /var/log/messages
        # This is useful if you have a dedicated syslog server
        [ $logtosyslog -eq 1  ] && $LOGGER "$sname service running : $status"

        # Update counters for next round
        c=$( expr $c + 1 )
        status="NO"
    done
    log "-------------------------------------------------------------"
    log "This is an automatically generated $(uname) service status notification by $0 script."

    if [ $sendmail -eq 1 ];
    then
        $MAIL -s "Service Down @ $(hostname)" $ADMINEMAIL < $LOG
    fi
}

### main ###
init_script
chk_services

### remove a log file ###
[ -f $LOG ] && /bin/rm -f $LOG
