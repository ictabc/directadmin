# directadmin
Directadmin scripts


scripts/letsencrypt.sh

- Add reading of /var/named/domain.db file for list of subdomains with same address of www.domain.com.
- Add recreating of domain.san_config to add subdomains when renewing or requesting.
- Add certificate for domain pointers

ToDo:

- Add SNI config for dovecot when adding new domain
- Add SNI config for EXIM when adding new domain

scripts/update-mail-certificate.sh

- Quick script to add SNI support to EXIM and Dovecot

ToDo:

- Integrate it with letsencrypt.sh
