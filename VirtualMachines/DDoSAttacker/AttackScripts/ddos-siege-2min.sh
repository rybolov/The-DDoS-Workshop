#!/bin/bash
echo "running siege -c50 -t 120S -u http://192.168.56.2/"
sleep 5
siege -c300 -t 120S http://192.168.56.2/?why=BecauseWeHateYou