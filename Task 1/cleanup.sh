#!/bin/bash
#This is a script to cleanup after the create.sh script

#***Functions***
#creating username base on email
createUsername(){
 local first=$(echo $1 | cut -c1)
 local last=$(echo $1 | cut -d'.' -f 2 | cut -d'@' -f 1)
 echo $first$last
}

#delete groups
createGroup(){
 for i in $(echo $1 | sed "s/,/;/g"); do
  if [[ $i != 'sudo' ]]; then
   sudo groupdel $i
  fi
 done
}

#delete shared folders
createSharedFolder(){
 if [ ! -z $1 ]; then
  sudo rmdir .${1}
 fi
}

#***Script***
#deleting user and anyting else that was created
file=$1
IFS=";"
sudo rm -f ./log
while read col1 col2 col3 col4; do
 username=$(createUsername $col1)
 createGroup $col3
 createSharedFolder $col4
 sudo userdel $username
 sudo rm -r /home/$username
done < <(tail -n +2 $file)
echo -e "All task completed .... Exiting!\n"
exit 0
