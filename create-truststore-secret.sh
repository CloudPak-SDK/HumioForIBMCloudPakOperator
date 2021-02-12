#!/bin/bash

oc -n ibm-common-services get secret cs-ca-certificate-secret -o jsonpath={.data."ca\.crt"} | base64 -d > ca.crt
keytool -import -trustcacerts -alias cp -file ca.crt -keystore truststore.jks -storepass changeit -noprompt
oc create secret generic truststore --from-file=truststore.jks