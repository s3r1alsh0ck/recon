#!/bin/bash

echo "Hi there, :)"
echo
echo "Recon process"
echo "1.Subdomain enumeration"
echo "2.httprobe"
echo "3.wayback urls"
echo "4.Eyewitness"
echo 
echo "Performing Subdomain enumeration...."
echo
python /root/tools/Sublist3r/sublist3r.py -d $1 -o /root/sub.txt
echo
curl -s https://certspotter.com/api/v0/certs\?domain\=$1 | jq '.[].dns_names[]' | sed 's/\"//g' | sed 's/\*\.//g' | sort -u | grep $1 | tee -a /root/sub.txt
echo
subfinder -d $1 -o /root/sub.txt
echo
findomain -t $1 -u /root/sub.txt
echo
cat /root/sub.txt | grep -Po "(\w+\.\w+\.\w+)$" | sort -u | tee -a /root/third-stage-sub.txt | wc -l
echo 
echo "1.subfinder"
echo "2.findomain"
echo "3.certspotter"
echo "4.sublist3r"
echo "5.ALL THE SCRIPTS [This take more time!!!]"
sleep 2
echo "Select a script to load!"
read n
echo 
echo 
if [ $n == 1 ]; then
echo "Looping with subfinder!!" 
for domain in $(cat /root/third-stage-sub.txt); do subfinder -d $domain -t 100 -o /root/subdomains.txt;done
echo "Done with looping!!"
fi

if [ $n == 2 ]; then
echo "Looping with findomains!!" 
for domain in $(cat /root/third-stage-sub.txt); do findomain -t $domain -u /root/subdomains.txt;done
echo "Done with looping!"
fi

if [ $n == 3 ]; then
echo "Looping with certspotter!!"
for domain in $(cat /root/third-stage-sub.txt); do curl -s https://certspotter.com/api/v0/certs\?domain\=$domain | jq '.[].dns_names[]' | sed 's/\"//g' | sed 's/\*\.//g' | sort -u | grep $domain | tee -a /root/subdomains.txt;done
echo "Done with looping!"
fi

if [ $n == 4 ]; then
echo "Looping with sublist3r!!"
for domain in $(cat /root/third-stage-sub.txt); do python /root/tools/Sublist3r/sublist3r.py -d $domain -o /root/subdomains.txt;done
echo "Done with looping!"
fi

if [ $n == 5 ];
then
 echo "Looping with all the above scripts!!!"
 for domain in $(cat $1); do python /root/tools/Sublist3r/sublist3r.py -d $domain -o more.subdomains.txt;done
 for domain in $(cat $1); do subfinder -d $domain -t 100 -o more.subdomains.txt;done
 for domain in $(cat $1); do findomain -t $domain -u more.subdomains.txt;done
 for domain in $(cat $1); do curl -s https://certspotter.com/api/v0/certs\?domain\=$domain | jq '.[].dns_names[]' | sed 's/\"//g' | sed 's/\*\.//g' | sort -u | grep $domain | tee -a /root/subdomains.txt;done
 echo
 echo "Done with looping!!!!!"
fi
echo
echo
cat /root/sub.old.txt >> /root/sub.txt
cat /root/subdomains.txt  >> /root/sub.txt
echo
cat /root/sub.txt | sort -u | sed 's/<.*//' |  tee -a /root/target-domains.txt
echo
echo "Checking for live domains....."
cat /root/target-domains.txt | sort -u | httprobe -s -p https:443 | sed 's/https\?:\/\///' | tr -d ":443" | tee -a /root/alive-domains.txt | wc -l
echo
echo "Looking for wayback urls...."
cat /root/alive-domains.txt | waybackurls | grep -v -e jpg -e png -e gif -e woff -e woff2 -e ttf -e svg -e jpeg -e css -e ico -e eot | sort -u | tee -a /root/wayback-domains.txt | wc -l
echo
echo "Taking screenshots of the target domains...."
./tools/EyeWitness/Python/EyeWitness.py -f /root/alive-domains.txt -d /root/eyewitness --prepend-https --web
echo
echo "Done!"
echo
echo "Execute next script..." 
