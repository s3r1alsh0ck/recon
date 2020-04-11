#!/bin/bash

echo "Hi there, :)"
echo
echo "Performing Subdomain enumeration...."
sublist3r -d $1 -o /root/sub.txt
echo
cat /root/sub.txt | grep -Po "(\w+\.\w+\.\w+)$" | sort -u | tee -a /root/third-stage-sub.txt | wc -l
echo
echo
for domain in $(cat /root/third-stage-sub.txt); do sublist3r -d $domain -o /root/final-sub.txt; cat /root/final-sub.txt | sort -u | tee -a /root/subdomains.txt;done
echo
cat /root/subdomains.txt | tee -a /root/sub.txt
echo
cat /root/sub.txt | sort -u | sed 's/<.*//' |  tee -a /root/final-domains.txt
echo
echo "Checking for live domains....."
cat /root/final-domains.txt | sort -u | httprobe -s -p https:443 | sed 's/https\?:\/\///' | tr -d ":443" | tee -a /root/alive-domains.txt | wc -l
echo
echo "Performing port scan...."
nmap -iL /root/alive-domains.txt -T5 -oA /root/ports-domains.txt
echo
echo "Looking for wayback urls...."
cat /root/alive-domains.txt | waybackurls | grep -v -e jpg -e png -e gif -e woff -e woff2 -e ttf -e svg -e jpeg -e css -e ico -e eot | sort -u | tee -a /root/wayback-domains.txt | wc -l
echo
echo "Taking screenshots of the target domains...."
eyewitness -f /root/alive-domains.txt -d /root/eyewitness --prepend-https --web
echo
echo "Done!"
echo
echo "Execute next script..." 
