#!/bin/sh
## param $1=PCAPFILE $2=IP $3=PORT $4=dry-run
TCP_TOOL=/home/freeman/TCP-homework/tapo/tcp_tool

if [ $# -ne 3 ]
then
	echo "Wrong parameters:"
	echo "Usage:"
	echo "    ./get_result.sh [PCAPFILE] [IP] [PORT]"
	exit
else
	if [ ! -x "filterd" ]
	then
		mkdir "filterd"
	fi
	if [ ! -x "results" ]
	then
		mkdir "results"
	fi
	tcpdump -r $1 host $2 and port $3 -w filterd/${1}.filt
	echo '[tcpdump complete]'
	${TCP_TOOL} -f filterd/${1}.filt -s $2 -p $3 -t up > results/${1}.raw
	inflight=""
	echo '[tapo complete]'
	#sed -i 's/.$//' results/${1}.txt
	#sed -i 's/$/\r/' results/${1}.txt
	awk '{if($1=="inflight_size") print;}' results/${1}.raw > results/${1}_inflight.txt
	awk '{if($1=="seq") print;}' results/${1}.raw > results/${1}_seq.txt
	echo ''
	echo '------------------------------------'
	echo 'Done!...What? Are you expecting me to draw the charts for you?'
	echo 'What a lazy bone :('
	echo 'Import the results in "results" directory into Excel and DoItYourself!'
fi
