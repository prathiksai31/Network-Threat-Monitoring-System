#@uthor 1: Sai Prathik
#@uthor 2: Nikhil Pinto
#Title: Shell script to automate wardriving using kismet tool. 

#!/bin/bash 
echo "Enter the SSID in quotes" 
read i
#echo "$i"

slash="/"
loc="/{ print NR-3}"
addr=$slash$i$loc
loc2="/{ print NR+10}"
addr2=$slash$i$loc2

loc3="/{ print NR-7}"
addr3=$slash$i$loc3

loc4="/{ print NR+8}"
addr4=$slash$i$loc4

loc5="/{ print NR+7}"
addr5=$slash$i$loc5

custom_timeout 30 "kismet_server daemonize"

sleep 10

while read l
do
	echo $l
done < <(awk "$addr" Kismet-1.nettxt)
temp=( $(awk "$addr" Kismet-1.nettxt) )
sed -n "$temp"p Kismet-1.nettxt > bssid.txt 
bssid=( $(sed 's/[^,:]*://p' bssid.txt | head -1) )
echo "BSSID $bssid"

temp1=( $(awk "$addr2" Kismet-1.nettxt) )
sed -n "$temp1"p Kismet-1.nettxt > channel.txt 
channel=( $(sed 's/[^,:]*://p' channel.txt | head -1) )
echo "Channel $channel"

temp2=( $(awk "$addr3" Kismet-1.nettxt) )
sed -n "$temp2"p Kismet-1.nettxt > manufacturer.txt 
manufact=( $(sed 's/[^,:]*://p' manufacturer.txt | head -1) )
echo "Manufacturer $manufact"

temp4=( $(awk "$addr4" Kismet-1.nettxt) )
sed -n "$temp4"p Kismet-1.nettxt > encryption2.txt 
ep2=( $(sed 's/[^,:]*://p' encryption2.txt | head -1) )
echo "Encryption2 $ep2"

temp5=( $(awk "$addr5" Kismet-1.nettxt) )
sed -n "$temp5"p Kismet-1.nettxt > open.txt 
open_encryption=( $(sed 's/[^,:]*://p' open.txt | head -1) )
#echo "WPA Version $open_encryption"


