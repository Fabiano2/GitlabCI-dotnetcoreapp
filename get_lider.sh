#!/bin/bash
echo "" > ./emails_lideres.txt
user="$1"
dbuser="redmine"
dbpass="redmine"
mysqlip="172.16.64.101"
mysqlport="3307"
basename="redmine_dbmysql"


user_id=$( mysql -u $dbuser -p'$dbpass' -h $mysqlip -P $mysqlport -D $basename -u $dbuser -p"$dbpass" -D redmine_db -Bse "SELECT id FROM redmine_db.users where login = '$user'";  )

echo "O id do usuario $user é $user_id"

project_id=$( mysql -u $dbuser -p'$dbpass' -h $mysqlip -P $mysqlport -D $basename -u $dbuser -p"$dbpass" -D redmine_db -Bse "SELECT project_id FROM redmine_db.members where user_id = '$user_id'";  )

echo "$user é membro de: "

echo "${project_id}" > teste.txt

mapfile -t project_id < teste.txt

i=0
goal=${#project_id[@]}
while [[ $i -lt $goal ]]
do 
	emails_lideres[$i]=$( mysql -u $dbuser -p'$dbpass' -h $mysqlip -P $mysqlport -D $basename -u $dbuser -p"$dbpass" -D redmine_db -Bse "SELECT email FROM redmine_db.project_leaders WHERE id_proj = '${project_id[$i]}';")

		emails_lideres[$i]=$( echo "${emails_lideres[$i]};" )

	i=$i+1
done	

i=0
while [[ $i -ne ${#project_id[@]} ]]
do
	a=0
	igual=0
	while [[ $a -lt ${#project_id[@]} ]]
	do		
		if [[ ${emails_lideres[$i]} == ${emails_lideres[$a]} ]]; then
			((igual++))
		fi
		if [[ $igual -gt 1 ]] && [[ "${emails_lideres[$a]}" ==  "${emails_lideres[$i]}" ]]; then
			unset 'emails_lideres[$a]'
		fi
		((a++))
	done
	i=$i+1
done

i=0
while [[ $i -ne ${#project_id[@]} ]]
do
	echo "${emails_lideres[$i]}" >> ./emails_lideres.txt
	((i++)) 
done

emails_lideres=$( cat /root/emails_lideres.txt | sed -r '/^\s*$/d' )

echo "$emails_lideres" > /root/emails_lideres.txt

emails_lideres=$( cat /root/emails_lideres.txt | tr -d '\n' )
echo "$emails_lideres" > /root/emails_lideres.txt