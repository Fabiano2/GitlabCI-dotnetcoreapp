#!/bin/bash

dbuser="redmine_db_user"
dbpass="redmine_db_userpassword"
mysqlip="ip.da.instancia.mysql"
mysqlport="porta_do_sql"
basename="nome_da_base"
login="$1"

twofa=$( mysql -u $dbuser -p'$dbpass' -h $mysqlip -P $mysqlport -D $basename  -Bse "SELECT twofa_scheme FROM redmine_db.users where login like '$login'"; )
logindb=$( mysql -u $dbuser -p'$dbpass' -h $mysqlip -P $mysqlport -D $basename -Bse "SELECT login FROM redmine_db.users where login like '$login'"; )
status=$( mysql -u $dbuser -p'$dbpass' -h $mysqlip -P $mysqlport -D $basename -Bse "SELECT status FROM redmine_db.users where login like '$login'"; )

echo "0" > ./exit.txt
echo "1" > ./comparar.txt

if [[ $twofa == "totp" ]] || [[ $status == 4 ]]; then


        mysql -u $dbuser -p'$dbpass' -h $mysqlip -P $mysqlport -D $basename -Bse "UPDATE redmine_db.users SET twofa_scheme = '' WHERE (login = '$login');"
        mysql -u $dbuser -p'$dbpass' -h $mysqlip -P $mysqlport -D $basename -Bse "UPDATE redmine_db.users SET status = 1 WHERE (login = '$login');"

        echo "================usuário desbloqueado com Sucesso!!!"
        #status
elif [[ $logindb == "" ]]; then
        echo "login não encontrado!"
        echo "========CAIU NO LOGIN VAZIO! (IF = TOTP)"
else
    echo "var twofa igual $twofa"
    echo "var logindb igual $logindb"
    echo "========JA DESBLOQUEADO (ELSE)"
    echo "1" > ./exit.txt
    chmod 777 ./exit.txt
    echo "========EXIT 1"
    #Erro: usuario ja desbloqueado
fi
