#!/bin/sh 

# Set Oracle Path and others as this will run as root not as oracle
ORACLE_HOME=/u01/app/oracle/product/11.2.0/dbhome_1  

export ORACLE_HOME
export PATH=$ORACLE_HOME/bin:$PATH
ORACLE_SID=orcl; export ORACLE_SID

# Set ftp location
HOST='FTP_SERVER_IP FTP_SERVER_PORT'
USER='USER_NAME'
PASSWD='PASSWORD'
FILEPATH='FTP_SERVER_NAME'

#Create backup rar

cd /home/oracle/Desktop/backup
tar -cvzf adump$(date +%d_%m_%y).tar.gz /u01/app/oracle/admin/orcl/adump
tar -cvzf trace$(date +%d_%m_%y).tar.gz /u01/app/oracle/diag/rdbms/orcl/orcl/trace
tar -cvzf cdump$(date +%d_%m_%y).tar.gz /u01/app/oracle/diag/rdbms/orcl/orcl/cdump

# Copy to FTP
cd /home/oracle/Desktop/backup
ftp -n -v $HOST << EOT
binary
user $USER $PASSWD
prompt
cd $FILEPATH
cd test
mput *.tar.gz
bye
EOT

#Remove existing content
find /u01/app/oracle/admin/orcl/adump -name "*.aud" -mtime +1 -exec rm - rf {} \;
find /u01/app/oracle/diag/rdbms/orcl/orcl/trace  -mtime +7 -exec rm - rf {} \;
find /u01/app/oracle/diag/rdbms/orcl/orcl/cdump  -mtime +7 -exec rm - rf {} \;

#Remove tar.gz content
cd /home/oracle/Desktop/backup
rm -rf *.tar.gz
