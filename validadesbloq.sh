#!/bin/bash

dbuser="redmine"
dbpass="redmine"
mysqlip="172.16.64.101"
mysqlport="3307"
basename="redmine_dbmysql"
login="$1"

login=$( mysql -u $dbuser -p'$dbpass' -h $mysqlip -P $mysqlport -D $basename -u redmine -p'redmine' -D redmine_db -Bse "SELECT login FROM redmine_db.users where login like '$login'"; )

if [[ $login == "" ]]; then
        echo "USUÁRIO NÃO ENCONTRADO!"
        exit 1
fi