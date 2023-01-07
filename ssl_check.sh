#!/bin/bash
#

certificate_file=$(mktemp)

trap "unlink $certificate_file" EXIT

if [ "$#" -eq "3" ]; then
  website="$1"
  port="$2"
  data="$3"

  if [ "$?" -eq "0" ]; then
    echo -n | openssl s_client -servername "$website" -connect "$website":"$port" 2>/dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > $certificate_file
    certificate_size=$(wc -c $certificate_file | awk '{print $1}')
    if [ "$certificate_size" -gt "1" ]; then
      date=$(openssl x509 -in $certificate_file -enddate -noout | sed "s/.*=\(.*\)/\1/")
      date_s=$(date -d "${date}" +%s)
      now_s=$(date -d now +%s)
      date_diff=$(( (date_s - now_s) / 86400 ))

      ssl_serial=$(openssl x509 -in $certificate_file -serial -noout | sed 's/.*=//g;s/../&:/g;s/:$//')
      ssl_issuer=$(openssl x509 -in $certificate_file -issuer -noout | sed 's/ = /=/g' | sed 's/issuer=//g')
      ssl_subject=$(openssl x509 -in $certificate_file -subject -noout | sed 's/ = /=/g' | sed 's/subject=//g')

      if [ $data == "expire_days" ]; then
         echo $date_diff
      fi

      if [ $data == "serial" ]; then
         echo $ssl_serial
      fi

      if [ $data == "ssl_subject" ]; then
         echo $ssl_subject
      fi

      if [ $data == "ssl_issuer" ]; then
         echo $ssl_issuer
      fi
    fi
  fi
fi

