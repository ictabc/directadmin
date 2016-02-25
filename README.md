# directadmin
Directadmin scripts


scripts/letsencrypt.sh

- Add reading of /var/named/domain.db file for list of subdomains with same address of www.domain.com.
- Add recreating of domain.san_config to add subdomains when renewing or requesting.

ToDo:

- Add SNI config for dovecot when adding new domain
- Add SNI config for EXIM when adding new domain
- Add certificate for domain pointers
