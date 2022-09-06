#!/bin/bash

#source file
source param.txt


#JSON STRING
string='{
        "Request": {
                "requestId": "RBMRT'$RANDOM'00'$RANDOM'",
                "keyword": "EMAIL",
                "sourceSystem": "RBM",
                "responseURL": "http://172.16.191.56:16080/MO_ROUTER/JSON_ADAPTER",
                "dataSet": {
                        "paramList": [{
                                "id": "template_id",
                                "value": "'$template_id'"
                        }, {
                                "id": "to",
                                "value": "'$to'"
                        }, {
                                "id": "filename",
                                "value": "'$filename'"
                        }, {
                                "id": "LANG_ID",
                                "value": "1"
                        }, {
                                "id": "BILLMON",
                                "value": "'$BILLMON'"
                        }, {
                                "id": "ACCTNUM",
                                "value": "'$ACCTNUM'"
                        }, {
                                "id":"SERVICES_LIST",
                                "value":"'$SERVICES_LIST'"
                        }, {
                                "id": "RIALACCBAL",
                                "value": "'$RIALACCBAL'"
                        }, {
                                "id": "DIRHAMACCBAL",
                                "value": "'$DIRHAMACCBAL'"
                        }, {
                                "id": "CUSTOMER_REF",
                                "value": "'$CUSTOMER_REF'"
                        }, {
                                "id": "TOTALAMOUNT",
                                "value": "'$TOTALAMOUNT'"
                        }, {
                                "id": "CUSTOMERNAME",
                                "value": "'$CUSTOMERNAME'"
                        }, {
                                "id": "OVERRULE",
                                "value": "LITIGATION_GENERIC_EMAIL_NOTIFY"
                        }]
                },
                "timestamp": "2021-07-13 19:30:07.78"
        }
}'
#request formation
echo $string
echo $string > req.json
b=0
#JSON HTTP GET CALL
#response=`curl -H "Content-Type: application/json" -d @req.json http://ip:port/end/url`
response=`curl -u username:pswd -i -H "Content-Type: application/json Accept:application/json" -d @req.json http://ip:port/end/url`

#creating res file
echo $response > res.json

grep_val=`grep 'successfully' res.json`

if [ ${#grep_val} != null ]
then
        sqlplus -s UAT_NGW/pswd@NGWDEV <<EOF

                        set feedback off
                        set pagesize 0

                        UPDATE ngw_generic_email_notification SET STATUS  = 'COMPLETED' WHERE SEQ_ID='$seq_id';

                        exit;
EOF
fi

rm -f res.json
