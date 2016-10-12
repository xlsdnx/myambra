#!/usr/bin/env bash

BUILD_DIR=/root

# small hack for waiting for db to come up
MYSQL_ROOT_PASSWORD=$COUNTER_DATABASE_ROOT_PASSWORD
MYSQL_USER=$COUNTER_DATABASE_USER
MYSQL_USER_PASSWORD=$COUNTER_DATABASE_PASSWORD
MYSQL_HOSTNAME=$COUNTER_HOSTNAME
MYSQL_DATABASE=$COUNTER_DATABASE

source $BUILD_DIR/run-helpers.sh

wait_until_db_service_up

process_template $BUILD_DIR/minion.yaml

if [[ $JAVA_DEBUG_PORT =~ ^[0-9]+$ ]] ; then
  DEBUG_FLAGS='-Xdebug -Xnoagent -Djava.compiler=NONE -Xrunjdwp:transport=dt_socket,address=8000,server=y,suspend=y'
fi

java -server -d64 $DEBUG_FLAGS -jar $BUILD_DIR/solr-indexer-*-jar-with-dependencies.jar -properties $BUILD_DIR/minion.yaml
