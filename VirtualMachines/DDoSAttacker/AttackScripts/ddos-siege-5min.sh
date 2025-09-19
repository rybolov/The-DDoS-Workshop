#!/bin/bash
echo "running siege -c50 -t 600S -u http://192.168.56.2/"
sleep 5
siege -c50 -t 600S -u http://192.168.56.2/