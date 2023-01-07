# zabbix-ssl-monitor
Solution to monitor multiple SSL-certificates straight from the Zabbix server or Zabbix proxy.

Main driver for this solution is ability to monitor multiple certificate from single point.

What we can monitor right now?
- remaining lifetime to the certificate
- certificate issuer
- certificate serial
- certificate subject

Monitored endpoints are created automatically based on seed file, all files are located in zabbix externalscript directory.

File ssl_hosts.cfg includes monitored endpoints and format is:
```
<hostname>:<port>:<optional comment>
<ip>:<port>:<optional comment>
```

Example ssl_hosts.cfg:
```
zabbix.acme.local:443
grafana.acme.local:443
ise.acme.local:443:Cisco ISE management interface
10.10.10.101:8910:Cisco ISE pxGrid interface
```

Executable script ssl_discovery.sh is used to discover monitored endpoints. Zabbix will create host prototypes based on this script.
Remember chmod and chown this file.

Executable script ssl_check.sh is used to monitor endpoints.

Installation:
- copy file ssl_discovery.sh and ssl_check.sh to Zabbix externalscript directory
- chmod and chown ssl_discovery.sh and ssl_check.sh files
- create ssl_hosts.cfg file
- upload template to you Zabbix server
- include uploaded template "SSL Servers" in Zabbix server or Zabbix proxy
- run execute now inside template

Template includes also triggers when certificate is about to expire.
