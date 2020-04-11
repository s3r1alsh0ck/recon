#!/bin/bash

mv /root/recon/final-domains.txt $1
mv /root/recon/alive-domains.txt $1
mv /root/recon/ports-domains.txt.nmap $1
mv /root/recon/wayback-domains.txt $1
mv /root/recon/automation/geckodriver.log $1
mv /root/recon/eyewitness $1
echo
echo "Files reached the destenation!!"

