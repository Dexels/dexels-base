#!/bin/bash

export flag="-Dfile.encoding=UTF-8 -XX:+UnlockExperimentalVMOptions -XX:+UnlockDiagnosticVMOptions -XX:NativeMemoryTracking=summary -XX:+PrintNMTStatistics"

# Set UseCGroupMemoryLimitForHeap options if required
if [ ! -z "$GCTHREADSSIZE" ] && [[ $GCTHREADSSIZE =~ ^-?[0-9]+$ ]]; then
  flag+=" -XX:ParallelGCThreads=$GCTHREADSSIZE"
else
  flag+=" -XX:ParallelGCThreads=1"
fi

if [ ! -z "$httpProxyHost" ]; then
  export httpProxyURL="http://${httpProxyHost}:${httpProxyPort}"
  export flag+=" -Dhttp.proxyHost=${httpProxyHost} -Dhttp_proxy=${httpProxyURL} -Dhttp.proxyPort=${httpProxyPort} -Dhttps.proxyPort=${httpProxyPort} -Dhttps.proxyHost=${httpProxyHost}";
  if [ ! -z "$nonProxyHosts"]; then
    export flag+= " -DnonProxyHosts=${nonProxyHosts}"
  fi
fi

if [ ! -z "$httpClientDebug" ]; then
  flag+=" -Dorg.apache.commons.logging.Log=org.apache.commons.logging.impl.SimpleLog"
  flag+=" -Dorg.apache.commons.logging.simplelog.showdatetime=true"
  flag+=" -Dorg.apache.commons.logging.simplelog.log.org.apache.http=DEBUG"
  flag+=" -Dorg.apache.commons.logging.simplelog.log.org.apache.http.wire=ERROR"
fi

# Set debug options if required
if [ ! -z "$JAVA_ENABLE_DEBUG" ] && [ "$JAVA_ENABLE_DEBUG" != "false" ]; then
    flag+=" -Dcom.sun.management.jmxremote"
    flag+=" -Dcom.sun.management.jmxremote.authenticate=false"
    flag+=" -Dcom.sun.management.jmxremote.ssl=false"
    flag+=" -Dcom.sun.management.jmxremote.local.only=false"
    flag+=" -Dcom.sun.management.jmxremote.port=1099"
    flag+=" -Dcom.sun.management.jmxremote.rmi.port=1099"
    flag+=" -Djava.rmi.server.hostname=127.0.0.1"
fi

if [ ! -z "$startflags" ]; then
  flag+=" $startflags"
fi

if [ -z "$LOGAPPENDERS" ]; then
  export LOGAPPENDERS=out
fi

if [ -z "$LOGLEVEL" ]; then
  export LOGLEVEL=INFO
fi

if [ -z "$CONSOLE_USER" ]; then
  export CONSOLE_USER=dexels
fi

if [ -z "$CONSOLE_PASS" ]; then
  export CONSOLE_PASS='{sha-256}eHpwVX+AFnneRThtRif+1CReQTxIkxHnQebptWE8aW4='
fi

if [ -z "$INTERACTIVE" ]; then
  export NONINTERACTIVE='-Dgosh.args=--nointeractive'
else
  export NONINTERACTIVE=''
fi

# TODO: before startup clean all the chached and compiled scripts in this volume, so that kube restarts act correctly
if [ -z "$FILE_REPOSITORY_PATH" ]; then
  echo "Clearing before startup..."
  rm -rf /storage/*
else
  echo "Detected FILE_REPOSITORY_PATH, so not deleting storage"
fi

rm -rf /opt/felix/felix-cache/*
cd /opt/felix

echo "# exec  java  -DLOGLEVEL=\"${LOGLEVEL}\"  -DLOGAPPENDERS=\"${LOGAPPENDERS}\"  ${FELIX_OPTS}  ${NONINTERACTIVE}  -DCONSOLE_USER=\"${CONSOLE_USER}\"  -DCONSOLE_PASS=\"${CONSOLE_PASS}\"  -Dmvncache=/opt/felix/mvncache  -Duser.dir=/opt/felix ${flag}  -jar bin/felix.jar"

exec java \
    -DLOGLEVEL="${LOGLEVEL}" \
    -DLOGAPPENDERS="${LOGAPPENDERS}" \
    ${FELIX_OPTS} \
    ${NONINTERACTIVE} \
    -DCONSOLE_USER="${CONSOLE_USER}" \
    -DCONSOLE_PASS="${CONSOLE_PASS}" \
    -Dmvncache=/opt/felix/mvncache \
    -Duser.dir=/opt/felix \
    ${flag} \
    -jar bin/felix.jar

