# Linux IN617 Assignment

## Author Infomation
**Author:** Panithan (Carthur) Pongpatimet  
**Student** Number: 1000026069  
**Student Code:** pongp1  
**Project** last modified: 18/09/2019  

## Project Infomation

### Task 1 (createUser.sh)
This script will create new users based on the infomation given by the CSV file that is given with the script
or manually entered once the script is running. The script will create new users, groups, user's home 
directory, shared folders, links to shared folders and alias for each user that is added. A log file will 
also be created which will contain all the output of the commands that was run in the script and any error 
that may have occured

#### **Intrustions**
There is two ways to insert file to be used by the script. 

**First option** - insert file (this can be pathway to the file) or url address to the file when you initially
run the script as an argument

*./createUser.sh users.csv* OR *./createUser.sh http://address/to/where/file/is*

**Second option** - give the file (this can be pathway to the file) or url address when the script prompt you
to do so.

For both options, if the url address is given then the file will be downloaded to the directory that the 
script was run. If the file was successfully loaded into the script, the script will prompt you say that
the file has been loaded succesfully. Then the user will then be asked if they want to create the users.
The users can choose to not add the users which will then cause the script to exit. 

### Task 2 (backup.sh)
This script will take in a directory (this can be pathway to the directory you want) that has been given with
the script or entered manually once the script is running. The script will then archived the directoy
specified and create a tar.gz file in the directory that the script was ran. This file will then be transfered
to a remote machine that the user will specify during the script. The aim of the script is to create a backup
of the entire specified directory on a remote machine. 

#### **Intrustions**
There is two ways to insert directory to be used by the script. 

**First option** - insert directory or pathway to the directory when you initally run the script as an
argument

*./backup.sh ./student OR *./backup.sh /home/student*

**Second option** - directory or pathway to the directory when the script prompt you to do so.

Once the script has created the tar.gz file, the user will be prompt to enter in the remote machine's infomation.
This will include information such as the username of the account you want to transfer the file to,
ip address of the remote machine, port number to transfer the file and target directory. 