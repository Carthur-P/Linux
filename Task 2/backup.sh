#!/bin/bash

#***Functions***
#compress file to tar.gz
compressFile(){
 if [ -d $1 ]; then
  sudo tar -zcvf ${1##*/}.tar.gz $1 &> /dev/null
  local exitCode=$?
  archivedFile=${1##*/}.tar.gz
  if [ $exitCode -ne 0 ]; then
   echo -e '\nFile could not be archived .... Exiting!\n'
   exit 2
  else
   echo -e '\nFile archived completed ... Accessing remote machine\n'
  fi
 else
  echo -e '\nDirectory not found .... Exiting!\n'
  exit 1
 fi
}

#uploading filerm
uploadFile(){
 echo 'Please provide information about remote device you want to upload to'
 echo -n 'Username: '
 read username
 echo -n 'Enter the IP adress: '
 read ipAddress
 echo -n 'Port number: '
 read portNumber
 echo -n 'Target Derectory: '
 read targetDir
 sudo scp -P $portNumber $archivedFile $username@$ipAddress:$targetDir
 if [ $? -ne 0 ]; then
  echo -e "\nThere was an error transfering file ...."
  echo -e "Please check that all information given for remote machine is correct .... Exiting!\n"
  exit 3
 else
  echo -e "\nFile transfered successful! .... All task completed .... Exiting!\n"
  exit 0
 fi
}

#***Script***
#checking if user have given an argument
if [ $# -ne 1 ]; then
 echo -n "Please enter the path to the directory that you want to be backup: "
 read filePath
 compressFile $filePath
 uploadFile
else
 compressFile $1
 uploadFile
fi
