#!/bin/bash

WORDLIST=rockyou.txt
HASH=42hDRfypTqqnw

ROCKYOU_PATH=$(locate $WORDLIST | head -n 1) # Get the path for rockyoulist

echo "$HASH" > hash.txt # Put the hash into a file for john

zcat $ROCKYOU_PATH | john --stdin ~/hash.txt 2> /dev/null && john --show hash.txt # UnZip rock you -> pass it to john and show the results

rm ./hash.txt 2> /dev/null # Clear temp file