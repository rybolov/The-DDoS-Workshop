#!/bin/bash

# Check if exactly one argument is provided
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <your_argument>"
  exit 1
fi

# Check if the file exists
if [ ! -f "$1" ]; then
  echo "File '$1' does not exist or is not a regular file."
fi

tcpdump -nn -v -r $1 | awk -F'proto' '{print $2}' | cut -d ' ' -f2 | egrep '^[A-Za-z0-9]{1,5}' | sort | uniq -c | head -n 20
