#!/usr/bin/env bash

source $HOME/run-helpers.sh

wait_until_db_service_up

if ! check_db_exists; then
  echo "Setting up schema"
  echo "DROP SCHEMA IF EXISTS ${MYSQL_DATABASE}; CREATE SCHEMA ${MYSQL_DATABASE};" | $MYSQL_ROOT
  $MYSQL_ROOT < $HOME/setup.mysql
  # TODO: run schema migrations
fi

set_db_grants

# wait until Mogile tracker is up

if [[ "$STORE_TYPE" == "Mogile" ]]; then

  while ! mogadm --trackers=$MOGILE_TRACKERS check >/dev/null 2>&1; do
    echo -e "\nMogile tracker not ready ... waiting"
    sleep 3
  done;

  echo "Mogile is ready"

fi

# TODO: make this work when a reproxy url is supplied
# hack to deal with empty string reproxy values
if [[ "$FS_REPROXY_URL" != "" ]]; then
  export FS_REPROXY_CLAUSE=reproxyBaseUrl=\"${FS_REPROXY_URL}\"
fi

process_env_template $CATALINA_HOME/conf/context.xml

start_tomcat.sh
