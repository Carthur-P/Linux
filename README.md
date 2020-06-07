# Otago Polytechnic Bachelor of Information Technology
## Paper - Linux (BIT - IN617001)
Bash scripts used to do two different tasks. This was created as part of the Otago Polytechnic Bachelor of Information technology Linux paper. 

## Task 1 (createUser.sh)
This script will create new users based on the information given in the CSV file. This CSV file can be given with the script or the file path/URL to the file can be manually entered once the script is running. The script will create new users, groups, user's home directory, shared folders, links to shared folders and alias for each user that is added. A log file will also be created which will contain all the output of the commands that ran in the script and any error that may have occurred during.

### Intructions
There are two ways to insert the CSV file to be used by the script. 

**First option** - Insert the file (this can be a pathway to the file or URL address to the file) when you initially run the script as an argument

*./createUser.sh users.csv* OR *./createUser.sh http://address/to/where/file/is*

**Second option** - Give the file (this can be the pathway to the file or URL address) when the script prompts you to do so.

For both options, if the URL address is given then the CSV file will be downloaded to the directory that the script was run at. If the file was successfully loaded into the script, the script will prompt you by saying that the file has been loaded successfully. The user can then choose if they want to go ahead and create the users If the user chooses to not create any users, the script will exit. 

The script cleanup.sh can be used to clean up the system by deleting all the users that were created by the createUser.sh script. The user will have to provide the same CSV file containing the user's information that was used by the create script. This can be given with the cleanup script as an argument or manually given when the script is running.

## Task 2 (backup.sh)
This script will take in one variable which is a file path to a directory that can be given with the script or entered manually once the script is running. The script will then archived the directory specified by turning the directory to a tar.gz file. This file will then be transferred to a remote machine that the user will specify during the script. The aim of this script is to create a backup
of the entire specified directory on a remote machine. 

### Intructions
There are two ways to insert the pathway to the directory to be used by the script. 

**First option** - Insert the pathway to the directory when you initially run the script as an argument

*./backup.sh home/student*

**Second option** - Pathway to the directory when the script prompts you to do so.

Once the script has created the tar.gz file, the user will be prompt to enter in the remote machine's information. Information that the user will have to provide are:

- Username of the account you want to transfer the file to
- The IP address of the remote machine
- Port number
- Target directory

