#! /usr/bin/bash
#set -x
pass=0
infile="Q1.txt"
counter=50

while IFS= read -r line; do
    [[ "${line:0:1}" == "L" ]] && d=-1 || d=1
    amt=${line:1}
    #echo ${line} ${d} ${amt} ${counter}
    counter=$( echo "(${counter} + ${d} * ${amt}) % 100" | bc )
    if [ ${counter} -lt 0 ]; then
        counter=$( echo "${counter} + 100" | bc )
    fi

    if [ ${counter} -eq 0 ]; then
        pass=$( echo "${pass} + 1" | bc )
        #echo ${line} ${counter} ${pass}
    fi
    #echo "=>" ${counter} ${pass}
done < ${infile}
echo ${line} ${counter}
echo ${pass}