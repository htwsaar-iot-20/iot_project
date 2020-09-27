#!/bin/bash

##############################################################################
#
# Dieses Skript erzeugt OTP und schreibt diese in /etc/ipsec.secrets
# Skript fuer die Client-Seite
#
# Autor: Tim Lorson
# Datum: 25.05.2020
#
##############################################################################

# Key auslesen
otp_key=`cat /home/tim/.2fa/key.txt | head -1l`

# Username
username="tlorson"

# Datei in der die OTP gespeichert werden
secrets_file="/etc/ipsec.secrets"

# OTP erstellen, verschluesseln und in /etc/ipsec.secrets einfuegen
encrypted_otp=`oathtool -b --totp "${otp_key}" | openssl dgst -sha256 | cut -d" " -f2`
sed -i "/"${username}"OTP/ c "${username}"OTP : EAP \""${encrypted_otp}"\"" "${secrets_file}"

ipsec rereadsecrets

exit 0;
