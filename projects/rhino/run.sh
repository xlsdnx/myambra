#!/bin/bash

BUILD_DIR=/root

SVC_WAR=rhino.war

source $BUILD_DIR/run-helpers.sh

wait_until_db_ready

# TODO: use a more up to date SQL schema dump
echo "CREATE SCHEMA IF NOT EXISTS $MYSQL_DATABASE" | $MYSQL_ROOT
$MYSQL_ROOT $MYSQL_DATABASE < ${BUILD_DIR}/ddl_mysql.sql

set_db_grants

cp /usr/local/tomcat/conf/* /etc/ambra
rm -rf /usr/local/tomcat/conf
ln -s /etc/ambra /usr/local/tomcat/conf
cp ${BUILD_DIR}/*.xml /etc/ambra
cp ${BUILD_DIR}/rhino.yaml /etc/ambra

setup_war_in_tomcat

wait_until_db_ready

start_tomcat