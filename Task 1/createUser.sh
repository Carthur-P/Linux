#!/bin/bash
IFS=";"

#***Functions***
#checking if argument is a URI or file
getFile(){
 if [ ! -f $1 ]; then
  echo -e "Downloading file ... \n"
  wget $1
  if [ $? -ne 0 ]; then
   echo -e "\nCould not download file from specified URI link .... Exiting!\n"
   echo "Error downloading file from the link given" >> ./log
   exit 1
  else
   file=${1##*/}
  fi
 else
  file=${1##*/}
 fi
}

#creating username base on email
createUsername(){
 local first=$(echo $1 | cut -c1)
 local last=$(echo $1 | cut -d'.' -f 2 | cut -d'@' -f 1)
 echo $first$last
}

#creating groups
createGroup(){
 for i in $(echo $1 | sed "s/,/;/g"); do
  if [[ $i != 'sudo' ]]; then
   sudo groupadd $i &>> ./log
  fi
 done
}

#creating shared folders
createSharedFolder(){
 if [ ! -z $1 ]; then
  sudo mkdir .${1} &> /dev/null
 fi
}

#creating links
createLink(){
 for i in $(echo $1 | sed "s/,/;/g"); do
  case $i in 
   'visitor') sudo ln -s /visitorData /home/$2/shared &>> ./log ;;
   'staff') sudo ln -s /staffData /home/$2/shared &>> ./log ;; 
  esac
 done
}

#creating alias
createAlias(){
 for i in $(echo $1 | sed "s/,/;/g"); do
  if [[ $i == 'sudo' ]]; then
  sudo touch /home/$2/.bash_aliases
  sudo chmod o+w /home/$2/.bash_aliases
  echo "alias off='systemctl poweroff'" >> /home/$2/.bash_aliases
  sudo chmod o-w /home/$2/.bash_aliases
  fi
 done
}

#counting number of added users
countingUsers(){
 counter=0
 while read; do
  let counter++
 done < <(tail -n +2 $file)
 return $counter
}

#adding the users/groups/shared folders/links/alias
createAllUsers(){
 while read col1 col2 col3 col4; do
  username=$(createUsername $col1)
  password=$(openssl passwd -1 $(date -d $col2 +"%m%Y"))
  createGroup $col3
  createSharedFolder $col4
  if [ ! -z $col3 ]; then
   sudo useradd -d /home/$username -m -s /bin/bash -G $col3 -p $password $username &>> ./log
   sudo chage -d 0 $username
  else
   sudo useradd -d /home/$username -m -s /bin/bash -p $password $username &>> ./log
   sudo chage -d 0 $username
  fi
  uaexitcode=$?
  case $uaexitcode in
   9) echo -e "User $username cannot be created beacuse it already exist .... Showing information"
      echo "Encrypted Password: $password"
      echo "Home Directory: /home/$username"
      echo "Shared Directory: $col4"
	  echo "Link: shared --> $col4"
      echo -e "Alias: off = systemctl poweroff\n" ;;
   10) -e "User could not be added beacause the group(s) you are trying to add the user to does not exist\n" ;;
   0) echo "The user $username has been added successfully! .... Showing information"
      echo "Encrypted Password: $password"
      echo "Home Directory: /home/$username"
      echo "Shared Directory: $col4"
	  echo "Link: shared --> $col4"
      echo -e "Alias: off = systemctl poweroff\n" ;;
   *) echo -e "User could not be added ... Exiting!\n"
      echo "Exiting because there was an error adding users" >> ./log; exit 2 ;;
  esac
  createLink $col3 $username
  createAlias $col3 $username
 done < <(tail -n +2 $file)
 sudo chown :staff ./staffData
 sudo chown :visitor ./visitorData
 sudo chown :visitor ./visitor
 sudo chmod 770 ./staffData
 sudo chmod 770 ./visitorData
 sudo chmod 770 ./visitor
 echo -e "All task completed .... Exiting!\n"
 echo "Script completed successfully" >> ./log
 exit 0
}

#***Script***
#creating log file
if [ ! -f log ]; then
 sudo touch log
 sudo chmod o+w ./log
 echo $(date) >> ./log
else
 echo " " >> ./log
 echo $(date) >> ./log
fi

#checking if user have given an argument
if [ $# -ne 1 ]; then
 echo -n "Please enter URI link or pathway to the file you want to be proccess: "
 read filePath
 echo 
 getFile $filePath
 echo -e "CSV file has been loaded! .... The file is called $file\n"
else
 getFile $1
 echo -e "CSV file has been loaded! .... The file is called $file\n"
fi

#asking if the user wants to add users
countingUsers
numUsers=$?
echo -e -n "$numUsers users will be added! .... Do you want to continue? (Y/N): "
read userAnswer
case $userAnswer in 
 Y|y|yes) echo -e '\nAdding users! .... please wait\n'; createAllUsers ;;
 N|n|no) echo -e '\nUser will not be added .... Exiting!\n'; 
         echo "User chose to not add user" >> ./log; exit 0 ;;
 *) echo -e '\nAnswer provided was not YES|NO .... Exiting!\n'
    echo "User did not give a yes or no answer" >> ./log; exit 3 ;;
esac
