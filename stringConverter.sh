#!/bin/bash

#script parameters
loader_data=loader_data.txt
CR_DATA=EN_DATA.txt
main_loop_count=`wc --lines < $loader_data`
json_sender_path="/home/nguser/RMB_RT_SCRIPT/jsonSender.sh"

#main loop
#string converter
for (( i=1; i<=$main_loop_count; i++ ))
do
         mrg_count=1
         #copy nth line of loader file
         del_line=`sed ''$i'!d' $loader_data`
         #copy last charactor
         last_ch=${del_line: -1}
         string_dl=","

         #define 2 error case
         if [ "$last_ch" = "$string_dl" ]
         then
                #case_1 with null value
                #grouping with dilimeter
                IFS=',' read -ra ADDR <<<"$del_line"

                for j in "${ADDR[@]}"
                do
                        #merging variables in file
                        echo $j >> 1.txt

                done

                #separate each variable from row file
                param=()
                row_variable=1.txt
                spliting_count=`wc --lines < 1.txt`
                for (( k=1; k<=$spliting_count; k++))
                do
                        #find position of '='
                        n_line=`sed -n ''$k'p' 1.txt`
                        n_position=`awk -F= '{print length($1)+1}' <<< "$n_line"`
                        echo $n_line > n$k.txt
                        param+=($n_position)
                done

                #for variable cretion
                for r in ${param[@]}
                do

                        #merging and deleting action
                        string=`sed 's/.\{'$r'\}/&"/' n$mrg_count.txt`
                        echo $string >> 5.txt
                        rm -f n$mrg_count.txt
                        mrg_count=`expr $mrg_count + 1`
                done

                #file rendering
                sed -i 's/$/"/' 5.txt
                head -n -1 5.txt > param.txt
                rm -f 1.txt 2.txt 3.txt 4.txt 5.txt

                #for essential params

                #copy nth line of ER file
                EN_line=`sed ''$i'!d' $CR_DATA`

                #grouping with dilimeter
                IFS=' ' read -ra ADDR <<<"$EN_line"

                for s in "${ADDR[@]}"
                do
                        #merging variables in file
                        echo $s >> 11.txt
                done
                param_ER=()
                reading_count=`wc --lines < 11.txt`
                for (( t=1; t<=$reading_count; t++))
                do
                        n_line=`sed -n ''$t'p' 11.txt`
                        param_ER+=($n_line)
                done

                #for variable cretion
                TEMPLATE_ID='template_id="'${param_ER[0]}'"'
                TO_EMAIL='to="'${param_ER[1]}'"'
                FILE_PATH='filename="'${param_ER[2]}'"'
                SEQ_ID='seq_id="'${param_ER[3]}'"'
                #merging variables
                echo $TEMPLATE_ID >> testvar.txt
                echo $TO_EMAIL >> testvar.txt
                echo $FILE_PATH >> testvar.txt
                echo $SEQ_ID >> testvar.txt
                cat testvar.txt >> param.txt
                echo ${param_ER[@]}
                rm -f 11.txt testvar.txt


                bash "$json_sender_path"
         else
                #grouping with dilimeter
                 IFS=',' read -ra ADDR <<<"$del_line"

                for j in "${ADDR[@]}"
                do
                        #merging variables in file
                        echo $j >> 1.txt

                done

                #for mergig last two lines
                mrg_count_n=`wc --lines < 1.txt`

                A1=`expr $mrg_count_n - 1`
                A2=$mrg_count_n

                #merging action
                awk 'FNR == '$A1' { print; next; } FNR == '$A2' { print; next; }' 1.txt | paste -sd '' > 2.txt
                head -n -2 1.txt > 3.txt
                cat 3.txt >> 4.txt
                cat 2.txt >> 4.txt

                #separate each variable from row file
                param=()
                row_variable=4.txt
                spliting_count=`wc --lines < 1.txt`
                for (( k=1; k<=$spliting_count; k++))
                do
                        #find position of '='
                        n_line=`sed -n ''$k'p' 4.txt`
                        n_position=`awk -F= '{print length($1)+1}' <<< "$n_line"`
                        echo $n_line > n$k.txt
                        param+=($n_position)
                done

                #for variable cretion
                for r in ${param[@]}
                do

                        #merging and deleting action
                        string=`sed 's/.\{'$r'\}/&"/' n$mrg_count.txt`
                        echo $string >> 5.txt
                        rm -f n$mrg_count.txt
                        mrg_count=`expr $mrg_count + 1`
                done

                #file rendering
                sed -i 's/$/"/' 5.txt
                head -n -1 5.txt > param.txt
                rm -f 1.txt 2.txt 3.txt 4.txt 5.txt

                #for essential params

                #copy nth line of ER file
                EN_line=`sed ''$i'!d' $CR_DATA`

                #grouping with dilimeter
                IFS=' ' read -ra ADDR <<<"$EN_line"

                for s in "${ADDR[@]}"
                do
                        #merging variables in file
                        echo $s >> 11.txt
                done
                param_ER=()
                reading_count=`wc --lines < 11.txt`
                for (( t=1; t<=$reading_count; t++))
                do
                        n_line=`sed -n ''$t'p' 11.txt`
                        param_ER+=($n_line)
                done

                #for variable cretion
                TEMPLATE_ID='template_id="'${param_ER[0]}'"'
                TO_EMAIL='to="'${param_ER[1]}'"'
                FILE_PATH='filename="'${param_ER[2]}'"'
                SEQ_ID='seq_id="'${param_ER[3]}'"'
                #merging variables
                echo $TEMPLATE_ID >> testvar.txt
                echo $TO_EMAIL >> testvar.txt
                echo $FILE_PATH >> testvar.txt
                echo $SEQ_ID >> testvar.txt
                cat testvar.txt >> param.txt
                bash "$json_sender_path"
                echo ${param_ER[@]}
                rm -f 11.txt testvar.txt
         fi

done

