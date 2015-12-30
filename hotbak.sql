set echo off
set heading off
set pagesize 9999
set linesize 120
set newpage none
set feadback off
spool /opt/bak/hot.sql rep 
select 'alter tablespace '||tablespace_name||' begin backup;'||chr(10)||'ho rsync -avlR '||file_name||' /opt/bak'||chr(10)||'alter tablespace '||tablespace_name||' end backup;' from dba_data_files;   
spool off 
ho sed '/SQL>/d' -i /opt/bak/hot.sql 
start /opt/bak/hot.sql 
ho rm -rf /opt/bak/con.bak 
alter database backup controlfile to '/opt/bak/con.bak';
ho rsync -avlR $ORACLE_HOME/dbs/spfile$ORACLE_SID.ora  /opt/bak 
ho rsync -avlR $ORACLE_HOME/dbs/orapw$ORACLE_SID  /opt/bak 
exit
