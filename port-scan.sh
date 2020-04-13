#!/bin/bash

echo "Performing port scan...."
nmap -iL /root/alive-domains.txt -T5 -oA /root/ports-domains.txt
echo
