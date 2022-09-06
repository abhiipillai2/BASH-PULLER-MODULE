#!/bin/bash

conveter_path="/home/nguser/RMB_RT_SCRIPT/stringConverter.sh"
dyn_filename=loader_data.txt
essential_filename=EN_DATA.txt


sqlplus -s UAT_NGW/ooredoo217@NGWDEV <<EOF

spool $dyn_filename;
set echo off
set define on
set verify off
set heading off
set serveroutput on
set pause off
set feedback off
set time off
set linesize 200
set longchunksize 200000
set long 20000
set pagesize 0
set trimspool on
column txt format a120

select DYN_TOKENS from NGW_GENERIC_EMAIL_NOTIFICATION where RETRY_COUNT = '10' and STATUS = 'CREATED';

spool off;
exit;
EOF


sqlplus -s UAT_NGW/ooredoo217@NGWDEV <<EOF

spool $essential_filename;
set echo off
set define on
set verify off
set heading off
set serveroutput on
set pause off
set feedback off
set time off
set linesize 2000
set pagesize 0
set trimspool on


select TEMPLATE_ID,TO_MAIL,FILE_PATH,SEQ_ID from NGW_GENERIC_EMAIL_NOTIFICATION where RETRY_COUNT = '10' and STATUS = 'CREATED';

spool off;
exit;
EOF

#call string script
bash "$conveter_path"

#remove fils
rm -f EN_DATA.txt param.txt loader_data.txt req.json

