#!/usr/bin/env bash

MYSQL_ROOT="mysql --default-character-set=utf8 -h ${MYSQL_HOSTNAME} -u root -p${MYSQL_ROOT_PASSWORD}"

$MYSQL_ROOT -e 'exit'
MYSQL_NOT_CONNECTING=$?
while [ $MYSQL_NOT_CONNECTING -ne 0 ] ; do
    sleep 1;
    $MYSQL_ROOT -e 'exit'
    MYSQL_NOT_CONNECTING=$?
    echo -e "\nDatabase (${MYSQL_HOSTNAME}) not ready ... waiting"
done;

echo -e "\nDatabase (${MYSQL_HOSTNAME}) ready!"

# TODO: inherit the waiting function from run-helpers

echo "db_dsn = DBI:mysql:mogilefs:host=$MYSQL_HOSTNAME" >> mogilefsd.conf
echo "db_user = $MYSQL_USER" >> mogilefsd.conf
echo "db_pass = $MYSQL_USER_PASSWORD" >> mogilefsd.conf

# TODO: inherit grant functions from run-helpers

echo "CREATE USER '${MYSQL_USER}' IDENTIFIED BY '${MYSQL_USER_PASSWORD}'" | ${MYSQL_ROOT}
echo "GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_USER}'@'%' WITH GRANT OPTION; FLUSH PRIVILEGES" | ${MYSQL_ROOT}

# NOTE: we should wait for the node to start but it seems fast enough

# TODO: only do dbsetup if the database is not setup already
mogdbsetup --yes --dbhost=$MYSQL_HOSTNAME --dbname=mogilefs --dbuser=$MYSQL_USER --dbpassword=$MYSQL_USER_PASSWORD --dbrootpassword=$MYSQL_ROOT_PASSWORD

adduser -D -G nogroup -s /bin/false -h /var/mogdata mogilefs
sudo -u mogilefs mogilefsd -c mogilefsd.conf
echo mogadm host add stored --ip=$MOG_NODE_HOST --port=7500 --status=alive
mogadm host add stored --ip=$MOG_NODE_HOST --port=7500 --status=alive
mogadm device add stored 1
mogadm check
mogadm domain add maindomain
mogadm domain list

tail -f /dev/null
