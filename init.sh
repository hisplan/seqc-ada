#!/bin/bash

execute=0

usage()
{
cat << EOF
USAGE: `basename $0` [options]
    -n  your main workflow name (e.g. CellHashing)
    -e  execute (without this flag, it will be a dry run)
EOF
}

while getopts "n:eh" OPTION
do
    case $OPTION in
        n) new_wf_name=$OPTARG ;;
        e) execute=1 ;;
        h) usage; exit 1 ;;
        *) usage; exit 1 ;;
    esac
done

if [ -z "$new_wf_name" ]
then
    usage
    exit 1
fi

old_wf_name="HelloWorld"

echo "(1) CHANGE WORKFLOW NAME"
list=`find . ! -path "./.git*" -type f ! -name "README.md" ! -name "init.sh" ! -name "*.bak" ! -name "*.zip" | xargs -I {} grep -l "$old_wf_name" {}`
for file in ${list}
do
    echo ${file}
    if [ $execute == 1 ]
    then
        sed -i "" "s|$old_wf_name|$new_wf_name|g" ${file}
    fi
done
echo "DONE."

echo

echo "(2) CHANGE FILENAME"
list=`find . ! -path "./.git*" -type f -name "HelloWorld*" ! -name "*.bak"`
for file in ${list}
do
    new_fn=`echo $file | sed "s|$old_wf_name|$new_wf_name|g"`
    echo "$file --> $new_fn"
    if [ $execute == 1 ]
    then
        mv $file $new_fn
    fi
done
echo "DONE."

echo

if [ $execute == 0 ]
then
    echo "THIS WAS A DRY RUN."
else
    echo "ALL EXECUTED."
fi
