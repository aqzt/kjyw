# 网上流传的简单记录操作的脚本
#vi /etc/profile.d/accountlog.sh
#chmod +x /etc/profile.d/accountlog.sh
#vi /etc/profile
#HISTTIMEFORMAT="%Y/%m/%d %H:%M:%S "   
historyLog(){

    logDir=/data/accountlog

    dateStamp=`date +"[%F %T]"`

    dateDir="`date +%Y`/`date +%m`/`date +%d`"

    curHistory=`history 1`

    user=`/usr/bin/whoami`

    realUserInfor=`/usr/bin/who -u am i|awk '{print $1,$2,$3"~"$4,$7}'`

    

    if [ ! -e $logDir ];then

        mkdir -p $logDir

        chmod 777 $logDir

    fi

 

    logDateDir=$logDir/$dateDir

    if [ ! -e $logDateDir ];then

        mkdir -p $logDateDir

        chmod -R 777 $logDir 2>/dev/null

    fi 

 

    accountLogDir=$logDateDir/${user:=`hostname`}

    if [ ! -e $accountLogDir ];then

        mkdir -p $accountLogDir

        #chmod 777 $accountLogDir

    fi

 

    accountLogName=${user:=`hostname`}.his

    accountLog=$accountLogDir/$accountLogName

    if [ ! -e "$accountLog" ];then

        touch $accountLog

        #chmod 777 $accountLog

    fi

    echo "$realUserInfor $dateStamp =>$curHistory" >>$accountLog

}

export PROMPT_COMMAND=historyLog
