set newpage none
set pagesize 9999
set heading off
set feedback off
set linesize 100
spool /opt/bak/cool.sql rep
select 'ho rsync -avlR '||value||' /opt/bak' from v$parameter where name='spfile';
select 'ho rsync -avlR '||name||' /opt/bak' from v$controlfile;
select 'ho rsync -avlR '||member||' /opt/bak' from v$logfile;
select 'ho rsync -avlR '||name||' /opt/bak' from v$datafile;
select 'ho rsync -avlR '||name||' /opt/bak' from v$tempfile;
spool off 
ho sed '/^ho rsync -avlR/p' -n /opt/bak/cool.sql > /opt/bak/cool1.sql 
shutdown immediate
start /opt/bak/cool1.sql 
ho rsync -avlR  $ORACLE_HOME/dbs/orapw$ORACLE_SID /opt/bak 
startup  
exit
