#!/bin/bash

echo "Hi there, :)"
echo
echo "Performing Subdomain enumeration...."
sublist3r -d $1 -o /root/recon/sub.txt
echo
cat /root/recon/sub.txt | grep -Po "(\w+\.\w+\.\w+)$" | sort -u | tee -a /root/recon/third-stage-sub.txt | wc -l
echo
echo
for domain in $(cat /root/recon/third-stage-sub.txt); do sublist3r -d $domain -o /root/recon/final-sub.txt; cat /root/recon/final-sub.txt | sort -u | tee -a /root/recon/subdomains.txt;done
echo
cat /root/recon/subdomains.txt | tee -a /root/recon/sub.txt
echo
cat /root/recon/sub.txt | sort -u | sed 's/<.*//' |  tee -a /root/recon/final-domains.txt
echo
echo "Checking for live domains....."
cat /root/recon/final-domains.txt | sort -u | httprobe -s -p https:443 | sed 's/https\?:\/\///' | tr -d ":443" | tee -a /root/recon/alive-domains.txt | wc -l
echo
echo "Performing port scan...."
nmap -iL /root/recon/alive-domains.txt -T5 -oA /root/recon/ports-domains.txt
echo
echo "Looking for wayback urls...."
cat /root/recon/alive-domains.txt | waybackurls | grep -v -e jpg -e png -e gif -e woff -e woff2 -e ttf -e svg -e jpeg -e css -e ico -e eot | sort -u | tee -a /root/recon/wayback-domains.txt | wc -l
echo
echo "Taking screenshots of the target domains...."
eyewitness -f /root/recon/alive-domains.txt -d /root/recon/eyewitness --prepend-https --web
echo
echo "Done!"
echo
echo "Execute next script..." 
