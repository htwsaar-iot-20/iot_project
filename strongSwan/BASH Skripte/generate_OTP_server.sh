#!/bin/bash

##############################################################################
#
# Dieses Skript erzeugt OTP und schreibt diese in /etc/ipsec.secrets
# Skript fuer die Server-Seite
#
# Autor: Tim Lorson
# Datum: 25.05.2020
#
##############################################################################

# Keys-Array
keyarray[0]=`cat /home/tlorson/.google_authenticator | head -1l` 
keyarray[1]=`cat /home/aklein/.google_authenticator | head -1l`
keyarray[2]=`cat /home/jvogt/.google_authenticator | head -1l`

# Name-Array
namearray[0]="tlorson"
namearray[1]="aklein"
namearray[2]="jvogt"

# Arraysize
size="${#keyarray[@]}"

# Datei in der die OTP gespeichert werden
secrets_file="/etc/ipsec.secrets"
#secrets_file="/var/lib/strongswan/otp.secrets"

# Alle Key-Files und Namen durchlaufen. OTP erstellen, Hashwert daraus erzeugen und diesen Hashwert in /etc/ipsec.secrets ablegen.
for (( i=0; i<"${size}"; i++ ))
do
  encrypted_otp=`oathtool -b --totp "${keyarray[${i}]}" | openssl dgst -sha256 | cut -d" " -f2`
  sed -i "/"${namearray[${i}]}"OTP/ c "${namearray[${i}]}"OTP : EAP \""${encrypted_otp}"\"" "${secrets_file}"
done

ipsec rereadsecrets

exit 0;
