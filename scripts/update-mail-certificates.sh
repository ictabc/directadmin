#!/bin/sh
dir=/usr/local/directadmin/data/users/
list=domains.list

echo -n "Updating exim certificate...."
for d in "$dir"*
do
	while read line
	do	
		if [ -f $d/domains/$line.cert ];
		then
			   cat $d/domains/$line.cert > /etc/exim.ssl/exim.cert.mail.$line
			   cat $d/domains/$line.key > /etc/exim.ssl/exim.key.mail.$line
			   cat $d/domains/$line.cacert >> /etc/exim.ssl/exim.cert.mail.$line
			   cat $d/domains/$line.cert > /etc/exim.ssl/exim.cert.smtp.$line
			   cat $d/domains/$line.key > /etc/exim.ssl/exim.key.smtp.$line
			   cat $d/domains/$line.cacert >> /etc/exim.ssl/exim.cert.smtp.$line
		fi
	done < $d/$list
done

#exim.conf
#tls_certificate = ${if exists{/etc/exim.ssl/exim.cert.${tls_sni}}{/etc/exim.ssl/exim.cert.${tls_sni}}{/etc/exim.cert}}
#tls_privatekey = ${if exists{/etc/exim.ssl/exim.key.${tls_sni}}{/etc/exim.ssl/exim.key.${tls_sni}}{/etc/exim.key}}


echo "Done!"

dovecot_ssl() {
cat > /etc/dovecot/certs/$1.conf << EOF
local_name imap.$1 {
  ssl_cert = </etc/dovecot/certs/$1.cert
  ssl_key = </etc/dovecot/certs/$1.key
}
local_name pop3.$1 {
  ssl_cert = </etc/dovecot/certs/$1.cert
  ssl_key = </etc/dovecot/certs/$1.key
}
local_name pop.$1 {
  ssl_cert = </etc/dovecot/certs/$1.cert
  ssl_key = </etc/dovecot/certs/$1.key
}
local_name smtp.$1 {
  ssl_cert = </etc/dovecot/certs/$1.cert
  ssl_key = </etc/dovecot/certs/$1.key
}
local_name mail.$1 {
  ssl_cert = </etc/dovecot/certs/$1.cert
  ssl_key = </etc/dovecot/certs/$1.key
}
EOF
}

dovecot_ssl_intermediate() {
cat > /etc/dovecot/certs/$1.conf << EOF
local_name imap.$1 {
  ssl_cert = </etc/dovecot/certs/$1.cert
  ssl_key = </etc/dovecot/certs/$1.key
  ssl_ca = </etc/dovecot/certs/$1.cacert
}
local_name pop3.$1 {
  ssl_cert = </etc/dovecot/certs/$1.cert
  ssl_key = </etc/dovecot/certs/$1.key
  ssl_ca = </etc/dovecot/certs/$1.cacert
}
local_name smtp.$1 {
  ssl_cert = </etc/dovecot/certs/$1.cert
  ssl_key = </etc/dovecot/certs/$1.key
  ssl_ca = </etc/dovecot/certs/$1.cacert
}
local_name mail.$1 {
  ssl_cert = </etc/dovecot/certs/$1.cert
  ssl_key = </etc/dovecot/certs/$1.key
  ssl_ca = </etc/dovecot/certs/$1.cacert
}
EOF
}

echo -n "Updating dovecot certificate...."
for d in "$dir"*
do
	while read line
	do	
		if [ -f $d/domains/$line.cert ];
		then
			if [ -f $d/domains/$line.cacert ]
			then
			   cp $d/domains/$line.cert /etc/dovecot/certs/$line.cert
			   cp $d/domains/$line.key /etc/dovecot/certs/$line.key
			   cp $d/domains/$line.cacert /etc/dovecot/certs/$line.cacert
			   dovecot_ssl_intermediate $line
			else
			   dovecot_ssl $line
			fi	
		fi
	done < $d/$list
done

echo -n "Reloading exim......"
service exim restart
echo "Done!"
echo -n "Reloading dovecot......"
service dovecot restart
echo "Done!"
echo "Done!"
