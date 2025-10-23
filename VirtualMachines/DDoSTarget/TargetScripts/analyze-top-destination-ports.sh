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

tcpdump -nn --r $1 | awk '{print $5}' | cut -sd. -f 5 | cut -sd: -f1 | sort | uniq -c | sort -nr | head -n 20

