#Contributors: Sai Prathik, Nikhil Pinto, Vidushi Razdan
#@uthor 1: Sai Prathik
#@uthor 2: Nikhil Pinto

#The entire shell script of our project titled "Network-Threat-Monitoring-System"


#!/bin/bash

custom_timeout() {
  time=$1

  command="/bin/sh -c \"$2\""

  expect -c "set echo \"-noecho\"; set timeout $time; spawn -noecho $command; expect timeout { exit 1 } eof { exit 0 }"

  if [ $? = 1 ] ; then
    echo "Timeout after ${time} seconds"
  fi

}
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

killall NetworkManager
killall NetworkManagerDispatcher
killall wpa_supplicant
killall avahi-daemon

#echo "test1"
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


custom_timeout 10 "airodump-ng wlan0mon"


custom_timeout 10 "airodump-ng -c $channel -w /root/six --bssid $bssid wlan0mon"


aircrack-ng -w /root/Desktop/mini_project/crunch.txt /root/six-01.cap | tee password.txt

cat password.txt | grep -q "KEY"

if [ $? = 0 ]; then
	keyfoundvar=1
	echo "Key 1 Found"
else 
	keyfoundvar=0
	echo "Key 1 Not Found"
fi
sleep 5
aircrack-ng -w /root/Desktop/mini_project/crunch_1to5.txt /root/six-01.cap | tee password2.txt
cat password2.txt | grep -q "KEY"

if [ $? = 0 ]; then
	keyfoundvar2=1
	echo "Key 2 Found"
else 
	keyfoundvar2=0
	echo "Key 2 Not Found"
fi
sleep 5
aircrack-ng -w /root/Desktop/mini_project/abc123.txt /root/six-01.cap | tee password3.txt
cat password3.txt | grep -q "KEY"

if [ $? = 0 ]; then
	keyfoundvar3=1
	echo "Key 3 Found"
else 
	keyfoundvar3=0
	echo "Key 3 Not Found"
fi




Encrypt=0
weight_encrypt=5
#Encryption = "$ep1"
if [ "$ep2" == "WPA+AES-CCM" ]; then
	Encrypt=$( expr 4 \* $weight_encrypt )
	elif [ "$ep2" == "WPA+PSK" ]; then
	Encrypt=$( expr 3 \* $weight_encrypt )
	elif [ "$ep2" == "WPA+TKIP" ]; then
	Encrypt=$( expr 2 \* $weight_encrypt )
	elif [ "$ep2" == "WEP" ]; then
	Encrypt=$(  expr 1 \* $weight_encrypt  )
	else
	Encrypt=0
fi
echo "Encryptionscoreis$Encrypt"

#KEY
KEY=0
key_weight=2
if [ "$keyfoundvar3" == 1 ]; then
	KEY=$( expr 3 \* $key_weight )
	elif [ "$keyfoundvar1" == 1 ]; then
	KEY=$( expr 2 \* $key_weight )
	elif [ "$keyfoundvar2" == 1 ]; then
	KEY=$( expr 1 \* $key_weight )   
	elif [ "$open_encryption" == "None" ]; then
	KEY=0   		
	else
	KEY=30
	   	
echo "KeyStrengthis$KEY"
fi

Manufact=0
weight_manufact=1

if [ "$manufact" == "Cisco" ]; then
	Manufact=$( expr 5 \* $weight_manufact )
	elif [ "$manufact" == "D-link" ]; then
	Manufact=$( expr 4 \* $weight_manufact )
	elif [ "$manufact" == "Netgear" ]; then
	Manufact=$( expr 3 \* $weight_manufact )
	elif [ "$manufact" == "TP-lnk" ]; then
	Manufact=$(  expr 2 \* $weight_manufact  )
	else
	Manufact=0
fi
echo "Manufacturerscoreis$Manufact"

Range=10
echo "Rangescoreis$Range"

Timing=15
echo "Timingscoreis$Timing"

Frequency=10
echo "Frequencyscoreis$Frequency"

#SNR=0
#echo "SNRscoreis$SNR"

SSL=10
echo "SSLscoreis$SSL"

total_score=$( expr $Encrypt + $KEY + $Manufact + $Range + $Timing + $Frequency + $SSL )
if (( $total_score >= 85 )); then
	security="Secure"
	elif (( $total_score >= 60 )); then
	security="Moderately Secure"
	else
	security="Not Secure"
fi

echo $total_score.$Encrypt.$KEY.$Manufact.$Range.$Timing.$Frequency.$SSL.$i.$security. >> /var/www/html/result.txt
echo $total_score.$Encrypt.$KEY.$Manufact.$Range.$Timing.$Frequency.$SSL.$i.$security. 
#$total_score.$Encrypt.$KEY.$Manufact.$Range.$Timing.$Frequency.$SSL.$i >> /var/www/html/result.txt
sleep 5

service network-manager restart
