#!/bin/bash

source $SCRIPTDIR/../projects/run-helpers.sh

COMPOSE_FILE=$SCRIPTDIR/../configurations/$COMPOSE_FILE

function die {
  echo "$@" 1>&2
  stop_stack
  exit 1
}

function get_docker_host {
  HOST="localhost"

  # if command -v boot2docker >/dev/null 2>&1 ; then
  #   HOST=$(boot2docker ip)
  # elif command -v docker-machine >/dev/null 2>&1 ; then
  #   HOST=$(docker-machine ip)
  # fi
  
  echo $HOST
}

function get_service_ip {
  CONTAINER_BASENAME=$1

  # CONTAINER=$(docker-compose -f $COMPOSE_FILE ps | grep $CONTAINER_BASENAME | awk 'END {print $1}')

  # workaround because the previous line does not work yet.
  # see: https://github.com/docker/compose/issues/1513

  CONTAINER=$(docker inspect -f '{{if .State.Running}}{{.Name}}{{end}}' $(docker-compose -f $COMPOSE_FILE ps -q) | sed 's/^\///' | grep $CONTAINER_BASENAME)

  echo $(docker inspect --format '{{ .NetworkSettings.IPAddress }}' $CONTAINER)
}

function start_stack {
  docker-compose -f $COMPOSE_FILE up -d
}

function stop_stack {
  docker-compose -f $COMPOSE_FILE kill
  docker-compose -f $COMPOSE_FILE rm -f
}

function curl_test_ok {

  URL=$1
  TITLE=$2
  echo "curling $URL  ($TITLE)"

  HTTP_CODE=$(curl -w "%{http_code}\\n" -s -o /dev/null $URL)
  if [[ "$HTTP_CODE" -ne "200" ]]; then
    echo "url = $URL   status code = $HTTP_CODE"
    die "TEST FAILED"
  fi
}
