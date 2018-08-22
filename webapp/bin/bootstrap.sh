#!/bin/sh

SCOUTER_SERVER=${SCOUTER_SERVER:-127.0.0.1}
SCOUTER_TCP_PORT=${SCOUTER_TCP_PORT:-6100}
SCOUTER_UDP_PORT=${SCOUTER_UDP_PORT:-6100}
SCOUTER_OBJECT_NAME=${SCOUTER_OBEJECT_NAME:-`hostname`}

# default Locale and Timezone
LANG=${LANG:-ko_KR.UTF-8}
TZ=${TZ:-Asia/Seoul}
JAVA_HOME=${JAVA_HOME:-/opt/oracle/java}
export LANG TZ JAVA_HOME

if [ -z "$CHARSET" ]; then
  CHARSET=`echo $LANG | sed -e 's/^.+\.//'`
  if [ -z "${CHARSET}" ]; then
    CHARSET=UTF-8
  elif locale -m $CHARSET 2>/dev/null | fgrep -vq $CHARSET; then
    CHARSET=UTF-8
  fi
fi

# Directories
APPROOT=${APPROOT:-/webapp}
LOGDIR=${LOGDIR:-${APPROOT}/logs}
TMPDIR=${TMPDIR:-/tmp}
export TMPDIR

# Application
BOOTAPP=${BOOTAPP:-${APPROOT}/application.jar}

# Java Options
#JAVA_BIN=${JAVA_HOME}/bin/java
JAVA_BIN="/bin/echo -- ${JAVA_HOME}/bin/java"
JVM_OPT=${JVM_OPT:-"-Xms64m -Xmx512m"}
JAVA_OPT="-Dfile.encoding=${CHARSET} \
          -Djava.io.tmpdir=${TMPDIR}"
if [ -f ${APPROOT}/config/scouter.conf ]; then
  sed -i \
    -e "s/\${SCOUTER_SERVER}/${SCOUTER_SERVER}/g" \
    -e "s/\${SCOUTER_TCP_PORT}/${SCOUTER_TCP_PORT}/g" \
    -e "s/\${SCOUTER_UDP_PORT}/${SCOUTER_UDP_PORT}/g" \
    -e "s/\${SCOUTER_OBJECT_NAME}/${SCOUTER_OBJECT_NAME}/g" \
    -e "s/\${LOGDIR}/${LOGDIR}/g" \
    $APPROOT/config/scouter.conf
  SCOUTER_OPT="-javaagent:${APPROOT}/scouter/agent.java/scouter.agent.jar \
               -Dscouter.config=${APPROOT}/config/scouter.conf
fi

case $cmd in
  start)
    cd $APPROOT
    exec $JAVA_BIN \
      $JVM_OPT \
      $JAVA_OPT \
      $SCOUTER_OPT \
      -jar $BOOTAPP \
      "$@"
    ;;

  selftest)
    if [ -f $APPROOT/config/selftest.yaml ]; then
      exec $APPROOT/bin/selftest.sh $APPROOT/config/selftest.yaml
    else
      echo "File not found: $APPROOT/config/selftest.yaml" >&2
    fi
    ;;

  *)
    echo usage: "$0 { start | selftest }"
    ;;
esac

