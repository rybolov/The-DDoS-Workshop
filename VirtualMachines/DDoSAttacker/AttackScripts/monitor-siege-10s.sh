#!/bin/bash
echo "running siege -c1 -t 10S -u http://192.168.56.2/"
sleep 2
siege -c1 -t 10S -d 1 http://192.168.56.2/