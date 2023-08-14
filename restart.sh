#!/bin/sh

echo "[INFO] Start application in release mode."
cd `dirname $0`
DEPLOY_DIR=`pwd`

SERVER_NAME="tdx-face-sdk-server_release.jar"

PIDS=`ps --no-heading -C java -f --width 1000 | grep "$SERVER_NAME" |awk '{print $2}'`

if [ -n "$PIDS" ]; then
    echo "ERROR: The $SERVER_NAME already started!"
    echo "PID: $PIDS"
#    exit 1
    echo -e "Stopping the $SERVER_NAME ...\c"
    for PID in $PIDS ; do
        kill $PID > /dev/null 2>&1
    done

    COUNT=0
    while [ $COUNT -lt 1 ]; do
        echo -e ".\c"
        sleep 1
        COUNT=1
        for PID in $PIDS ; do
            PID_EXIST=`ps --no-heading -p $PID`
                if [ -n "$PID_EXIST" ]; then
                    COUNT=0
                    break
                fi
        done
    done
    echo "OK!"
fi

LOGS_DIR=""
LOGS_DIR=${DEPLOY_DIR}/logs

if [ ! -d ${LOGS_DIR} ]; then
        mkdir ${LOGS_DIR}
fi
STDOUT_FILE=${LOGS_DIR}/stdout.log
STDOUT_LAST_FILE=${LOGS_DIR}/stdout.last

mv ${STDOUT_FILE} ${STDOUT_LAST_FILE}

echo -e "Starting the $SERVER_NAME ...\c\r\n"

JAVA_OPTS="-server -Xmx1g -XX:MetaspaceSize=128m -Djava.security.egd=file:/dev/./urandom"

nohup java ${JAVA_OPTS} -jar ${SERVER_NAME} > ${STDOUT_FILE} 2>&1 &

COUNT=0
while [ ${COUNT} -lt 1 ]; do
    echo -e ".\c"
    sleep 1
        COUNT=`ps  --no-heading -C java -f --width 1000 | grep "$SERVER_NAME" | awk '{print $2}' | wc -l`
        if [ ${COUNT} -gt 0 ]; then
                break
        fi
done
echo "OK!"
PIDS=`ps  --no-heading -C java -f --width 1000 | grep "$SERVER_NAME" | awk '{print $2}'`
echo "PID: $PIDS"
echo "STDOUT: $STDOUT_FILE"