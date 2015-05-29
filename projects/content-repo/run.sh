#!/bin/bash

BUILD_DIR=/root

SVC_WAR=*.war

source $BUILD_DIR/run-helpers.sh

cp ${BUILD_DIR}/context.xml ${CATALINA_HOME}/conf/context.xml

wait_until_db_ready

echo "DROP SCHEMA IF EXISTS ${MYSQL_DATABASE}; CREATE SCHEMA ${MYSQL_DATABASE};" | $MYSQL_ROOT
$MYSQL_ROOT < ${BUILD_DIR}/setup.mysql

set_db_grants

setup_war_in_tomcat

start_tomcat