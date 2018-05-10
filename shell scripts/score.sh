#Contributors: Vidushi Razdan, Sai Prathik, Nikhil Pinto
#Title: Score Algorithm to determine the security standards of a Wireless Network 

#!/bin/bash 


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

