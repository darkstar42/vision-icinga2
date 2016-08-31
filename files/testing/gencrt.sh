#!/usr/bin/env bash
openssl genrsa -out /tmp/dummyCA.key 1024
openssl req -x509 -new -nodes -key /tmp/dummyCA.key -sha256 -days 1 -out /tmp/dummyCA.pem -subj "/C=US/ST=CA/O=Acme, Inc./CN=example.com"

openssl genrsa -out /tmp/dummycert.key 1024
openssl req -new -key /tmp/dummycert.key -out /tmp/dummycert.csr -subj "/C=GB/ST=No/L=London/O=Security/OU=foobar/CN=`/opt/puppetlabs/bin/facter fqdn`"
openssl x509 -req -in /tmp/dummycert.csr -CA /tmp/dummyCA.pem -CAkey /tmp/dummyCA.key -CAcreateserial -out /tmp/dummycert.crt -days 1
