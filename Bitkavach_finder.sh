#!/bin/bash

# Check if a domain is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <domain>"
    exit 1
fi

DOMAIN=$1
OUTPUT_FILE="unique_subdomains.txt"

echo "[+] Finding subdomains for: $DOMAIN"

# Running assetfinder
echo "[+] Running assetfinder..."
assetfinder --subs-only $DOMAIN | tee assetfinder.txt

# Running subfinder
echo "[+] Running subfinder..."
subfinder -d $DOMAIN -silent | tee subfinder.txt

# Running sublist3r
echo "[+] Running sublist3r..."
python3 ~/Sublist3r/sublist3r.py -d $DOMAIN -o sublister.txt >/dev/null

# Running amass
echo "[+] Running amass..."
amass enum -passive -d $DOMAIN | tee amass.txt

# Combining results and removing duplicates
echo "[+] Removing duplicates..."
cat assetfinder.txt subfinder.txt sublister.txt amass.txt | sort -u > $OUTPUT_FILE

# Displaying the result
echo "[+] Unique subdomains found:"
cat $OUTPUT_FILE

# Cleanup intermediate files
rm assetfinder.txt subfinder.txt sublister.txt amass.txt

echo "[+] Results saved to $OUTPUT_FILE"
