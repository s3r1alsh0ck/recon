#!/bin/bash

mv /root/target-domains.txt $1
mv /root/alive-domains.txt $1
mv /root/ports-domains.txt.nmap $1
mv /root/wayback-domains.txt $1
mv /root/automation/geckodriver.log $1
mv /root/eyewitness $1
echo
echo "Files reached the destenation!!"

