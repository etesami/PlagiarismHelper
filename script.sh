#!/usr/bin/env bash

help="Usage: 
    ./script DIR GROUPS_DIR"
eval "$(docopts -A args -h "$help" : "$@")"

source ~/.colors
ROOT_FOLDER=${args[DIR]}
GROUPS_DIR=${args[GROUPS_DIR]}
MOSS_FOLDER="${args[DIR]}/moss_source"
SUBMMITED_GROUPS="${args[DIR]}/moss_groups_submission"
NO_SUBMISSIONS="${args[DIR]}/moss_no_submission"


echo -e "${red}Please run this script only one time. If anything goes wrong\nremove the assignment folder and run it again.\n\nPress [enter] to continue...${noc}"
read asd

touch $SUBMMITED_GROUPS
touch $NO_SUBMISSIONS

for ID in `ls $ROOT_FOLDER`; do
    CHECK=`echo $ID | grep moss` 
    if [[ -z $CHECK ]]; then # make sure it is not a text file
        echo 
        DIR=$ROOT_FOLDER"/"$ID
        CONTENT=`ls $DIR`
        if [[ -z $CONTENT ]]; then # make sure there is a submission
            echo -e "${red}----------------------------------------------------${noc}"
            echo -e "${red}            NO SUBMISSION FOUND: $ID${noc}"
            echo $ID | tee -a $NO_SUBMISSIONS > /dev/null
            echo -e "${red}----------------------------------------------------${noc}"
        else
            echo -e "${grn}Found a submission: ${cyn}$ID${noc}"

            GROUP_ID=`cat $GROUPS_DIR | grep $ID | awk {'print $2'}` # get the group name (group ID)
            if [[ -n $GROUP_ID ]]; then # if the group name exists in the file
                GROUP_ID_=`cat $SUBMMITED_GROUPS | grep $GROUP_ID`
                if [[ -n $GROUP_ID_ ]]; then # group name exists, skip this submission
                    echo -e "${ylw}--> Submission for this group has already processed: $GROUP_ID_${noc}"
                    continue
                fi
                echo $GROUP_ID | tee -a $SUBMMITED_GROUPS > /dev/null
            else
                echo -e "${ylw}----------------------------------------------------${noc}"
                echo -e "${ylw} This submission does not have any associated group.${noc}"
                echo -e "${ylw}----------------------------------------------------${noc}"
            fi

            echo -e "--> Extracting the submissions for $ID..."

            # Check zip or tar.gz file is uploaded
            LL=`find $DIR -type f \( -name "*.zip" \)`
            if [[ -n $LL ]]; then # zip file found
                echo "--> Extracting "$LL
                unzip -o $LL -d $DIR
            else
                LL=`find $DIR -type f \( -name "*.tar.gz" \)`
                if [[ -n $LL ]]; then # tar.gz file found
                    echo "--> Extracting "$LL
                    tar -zxf $LL -C $DIR
                else
                    echo -e "${red}[ERROR] NO Compressed file found: $ID${noc}"
                    continue
                fi
            fi

            # Looking for c, makefile files
            ll=`find $DIR -type f \( -name "*.c" -o -name "Makefile" -o -name "MAKEFILE" \) | sed 's/ /\&\;/g'`
            if [[ -n $ll ]]; then # make sure the c files are uplaoded
                mkdir -p "$MOSS_FOLDER/$ID"
                for aa in $ll; do
                    aa=`echo $aa | sed 's/\&\;/\*/g'`
                    cp $aa "$MOSS_FOLDER/$ID"
                done
                CHECK=`ls -1 $MOSS_FOLDER/$ID | wc -l`
                if [[ $CHECK -lt 2 ]]; then # make sure there exactly two .c files
                    echo -e "${red}--> Source *.c files have a problem: $ID${noc}"
                else
                    echo -e "${grn}--> Source *.c files are OK: $ID${noc}"
                fi
            else
               echo -e "${red}--> No .c file found: $ID${noc}"
            fi
        fi
    fi
done


