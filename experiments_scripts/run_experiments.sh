#!/bin/bash
# run_experiments.sh: Mateus Sousa (UFBA - 2018)
#
# This script:
#		used to perform my experiments over the ndnsim simulator
#		
# 
#
#
#
# It is very limited! Only for my purposes ;)

_n=(25 50 75 100)
_scenario=('mobility' 'highway')
_strategy="multi"
_percentage_of_producers=(0.5 0.15 0.20 0.25)
_save_to_dir="/tmp/lsif-${_n}-${_percentage_of_producers}-${_scenario}-${_strategy}"
_sim_time=(152.0 400.0)

for percent in "${_percentage_of_producers[@]}"
do
	for scenario in "${_scenario[@]}"
	do
		for n in "${_n[@]}"
		do
			echo "Running ${scenario}${n} with ${percent}% of producers..."
			../waf --run "vanets_ndn --traceFile=/home/mateus/${scenario}${n} --n=$n --simTime=153.00 --lsif=true --producers=$percent" &> /dev/null
			[ $? -ne 0 ] && echo "[!] Error on simulation!" && exit -1
			_save_to_dir="/tmp/lsif-${n}-${percent}-${scenario}-${_strategy}"
			mkdir "$_save_to_dir" 2> /dev/null
			mv /tmp/*.txt "$_save_to_dir" 
			mv ../'vndn-trace-file.txt'  "$_save_to_dir" 
		done
	done
done

