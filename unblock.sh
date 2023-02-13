#!/bin/bash

dbuser="redmine"
dbpass="redmine"
mysqlip="172.16.64.101"
mysqlport="3307"
basename="redmine_dbmysql"
login="$1"

twofa=$( mysql -u $dbuser -p'$dbpass' -h $mysqlip -P $mysqlport -D $basename -u redmine -p'redmine' -D redmine_db -Bse "SELECT twofa_scheme FROM redmine_db.users where login like '$login'"; )
logindb=$( mysql -u $dbuser -p'$dbpass' -h $mysqlip -P $mysqlport -D $basename -u redmine -p'redmine' -D redmine_db -Bse "SELECT login FROM redmine_db.users where login like '$login'"; )
status=$( mysql -u $dbuser -p'$dbpass' -h $mysqlip -P $mysqlport -D $basename -u redmine -p'redmine' -D redmine_db -Bse "SELECT status FROM redmine_db.users where login like '$login'"; )


if [[ $status == 4 ]]; then
        mysql -u $dbuser -p'$dbpass' -h $mysqlip -P $mysqlport -D $basename -u redmine -p'redmine' -D redmine_db -Bse "UPDATE redmine_db.users SET status = 1 WHERE (login = '$login');"
        echo "========STATUS IGUAL A 4! (IF STATUS 4)"
        exit 1
fi
exit 1
if [[ $twofa == "totp" ]]; then


        mysql -u $dbuser -p'$dbpass' -h $mysqlip -P $mysqlport -D $basename -u redmine -p'redmine' -D redmine_db -Bse "UPDATE redmine_db.users SET twofa_scheme = '' WHERE (login = '$login');"

        echo "================usuário desbloqueado com Sucesso!!!"
        #status
elif [[ $logindb == "" ]]; then
        echo "login não encontrado!"
        echo "========CAIU NO LOGIN VAZIO! (IF = TOTP)"
else
    echo "var twofa igual $twofa"
    echo "var logindb igual $logindb"
    echo "========JA DESBLOQUEADO (ELSE)"
    exit 1
    echo "========EXIT 1"
    #Erro: usuario ja desbloqueado
fi
