#!/bin/sh
## param $1=PCAPFILE $2=IP $3=PORT $4=dry-run
TCP_TOOL=/home/freeman/TCP-homework/tapo/tcp_tool

sender_raw=`tcpdump -n -r ${1} | awk '{print $3}' | sort |  uniq -c | sort -k 1 -n -r | awk 'NR==1 {print $2}'`
IP=`echo  $sender_raw | awk -F . '{print $1"."$2"."$3"."$4}'`
PORT=`echo $sender_raw | awk -F . '{print $5}'`

if [ $# -ne 3 -a $# -ne 1 ]
then
	echo "Wrong parameters:"
	echo "Usage:"
	echo "  (Automatically):"
	echo "    ./get_result.sh [PCAPFILE]"
	echo "  (or manually):"
	echo "    ./get_result.sh [PCAPFILE] [IP] [PORT]"
	exit
fi

if [ ! -x "filterd" ]
then
	mkdir "filterd"
fi
if [ ! -x "results" ]
then
	mkdir "results"
fi
tcpdump -r $1 host ${IP} and port ${PORT} -w filterd/${1}.filt
echo '[tcpdump complete]'
${TCP_TOOL} -f filterd/${1}.filt -s ${IP} -p ${PORT} -t up > results/${1}.raw
inflight=""
echo '[tapo complete]'
#sed -i 's/.$//' results/${1}.txt
#sed -i 's/$/\r/' results/${1}.txt
awk '{if($1=="inflight_size") print;}' results/${1}.raw | awk '{print $4"	" $2}'> results/${1}_inflight.dat
awk '{if($1=="seq") print;}' results/${1}.raw | awk '{print $4"	" $2}' > results/${1}_seq.dat
echo '[datafile generated]'
touch results/${1}_seq.plot
echo "set term jpeg" > results/${1}_seq.plot
echo "set output '${1}_seq.jpg'" >> results/${1}_seq.plot
echo "set xlabel 'time (s)'" >> results/${1}_seq.plot
echo "set ylabel 'sequence number'" >> results/${1}_seq.plot
echo "plot '${1}_seq.dat'" >> results/${1}_seq.plot
echo "reset" >> results/${1}_seq.plot
cd results
gnuplot ${1}_seq.plot
sleep 0.1
cd ..
touch results/${1}_inflight.plot
echo "set term jpeg" > results/${1}_inflight.plot
echo "set output '${1}_inflight.jpg'" >> results/${1}_inflight.plot
echo "set logscale y" >> results/${1}_inflight.plot
echo "set xlabel 'time (s)'" >> results/${1}_inflight.plot
echo "set ylabel 'inflight size (Bytes)'" >> results/${1}_inflight.plot
echo "plot '${1}_inflight.dat'" >> results/${1}_inflight.plot
echo "reset" >> results/${1}_inflight.plot
cd results
gnuplot ${1}_inflight.plot
sleep 0.1
cd ..
echo "drawing plots complete"
echo ''
echo '------------------------------------'
echo 'Done!...What? Are you expecting me to upload the homework for you?'
echo 'You are such a lazy bone :('
echo 'Check the results in "results" directory and DoItYourself!'
