#!/usr/bin/dash
cpu_cores=4

# default values
t_warn=50
t_crit=80
cpu_sum_old=0
load_sum_old=0
color="#FFFFFF"
color_warn="#FFF600"
color_crit="#EC819E"

while true 
do

   tmp=$(head -n 1 /proc/stat)
    
   arr=$(echo $tmp | tr " " "\n")
   cpu_sum=0
   load_sum=0
   index=0
    for x in $arr
    do
        if [ $index = 4 ];
        then
            cpu_sum=$((cpu_sum+x))
        elif [ $index -gt 0 ];
        then
            cpu_sum=$((cpu_sum+x))
            load_sum=$((load_sum+x))
        fi
        index=$((index+1))
    done
    percentage=$(((load_sum-load_sum_old)*100/(cpu_sum-cpu_sum_old)))  
    
    
    if [ $t_crit -lt $percentage ];
    then
        color=$color_crit
    elif [ $t_warn -lt $percentage ];
    then
        color=$color_warn
    else
	color="#FFFFFF"
    fi
    if [ $percentage -lt 10 ];
    then
	promille=$(((load_sum-load_sum_old)*1000/(cpu_sum-cpu_sum_old)-percentage*10))      
	echo "<span foreground=\"$color\"> ${percentage}.${promille}%</span>"
    else 
	echo "<span foreground=\"$color\"> ${percentage}%</span>"
    fi	
    cpu_sum_old=$cpu_sum
    load_sum_old=$load_sum
	sleep 2
done
