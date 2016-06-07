#!/bin/sh
#
# Purpose: This script starts and stops the $DAEMON_NAME daemon
#
# License: GPL
#
# chkconfig: 345 80 30  ## Add chkconfig
# description: Starts Kafka
# Source function library.
. /etc/rc.d/init.d/functions


USER=root
DAEMON_PATH=/opt/kafka_2.10-0.9.0.1/bin
DAEMON_NAME=kafka
# Check that networking is up.
#[ ${NETWORKING} = "no" ] && exit 0

PATH=$PATH:$DAEMON_PATH

# See how we were called.
case "$1" in
  start)
        # Start daemon.
        echo -n "Starting $DAEMON_NAME: ";echo
        /bin/su $USER $DAEMON_PATH/kafka-server-start.sh /opt/kafka_2.10-0.9.0.1/config/server.properties >/dev/null 2>> /var/log/kafka.log  &
		#/bin/su root /opt/kafka_2.10-0.9.0.1/bin/kafka-server-start.sh /opt/kafka_2.10-0.9.0.1/config/server.properties >/dev/null 2>> /var/log/kafka.log  &
		echo ok
        ;;
  stop)
        # Stop daemons.
        echo -n "Shutting down $DAEMON_NAME: ";echo
        #$DAEMON_PATH/kafka-server-stop.sh
        ps ax | grep -i 'kafka.Kafka' | grep -v grep | awk '{print $1}' | xargs kill
		echo ok
        ;;
  restart)
        $0 stop
         sleep 1
        $0 start
        ;;
  *)
        echo "Usage: $0 {start|stop|restart}"
        exit 1
esac