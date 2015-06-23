#!/bin/bash

TOMCAT=${1}
PID=`ps -eo pid,command | grep java| grep ${TOMCAT}| awk -F " " '{ print \$NR }' `
RETURN=`kill ${PID}`
sleep 5

STATUS=`ps -eo pid,command | grep java| grep ${TOMCAT}| awk -F " " '{ print \$NR }' | wc -l`

if [ ${STATUS} -gt 0 ]; then
	RETURN=`kill -9 ${PID}`
	exit 0
fi
