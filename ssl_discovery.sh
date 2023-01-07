#!/bin/bash
input="/usr/lib/zabbix/externalscripts/ssl_hosts.cfg"

last_line=$(wc -l < $input)
current_line=0


echo "{"
echo "\"SSLSERVERS\": ["

while read -r line; do

  host=$(echo $line| awk -F ':' '{print $1}')
  port=$(echo $line| awk -F ':' '{print $2}')

  current_line=$(($current_line + 1))
  echo "{"
  echo "\"sslserver\": \"$host\","
  echo "\"sslport\": \"$port\""
  if [[ $current_line -ne $last_line ]]; then
    echo "},"
  else
    echo "}]"
  fi
done < $input

echo "}"

