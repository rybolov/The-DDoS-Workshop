#!/bin/bash

#### This is run every minute from cron

#### wait 1-60 seconds to add a little bit of timing randomness
MINWAIT=1
MAXWAIT=60
SLEEP_TIME=$(( MINWAIT + RANDOM % (MAXWAIT - MINWAIT + 1) ))
sleep "$SLEEP_TIME"

#### Get a random user-agent to use with curl
user_agents=(
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.82 Safari/537.36"
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_5) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.1.1 Safari/605.1.15"
    "Mozilla/5.0 (iPhone; CPU iPhone OS 10_0_1 like Mac OS X) AppleWebKit/602.1.50 (KHTML, like Gecko) Version/10.0 Mobile/14A403 Safari/602.1"
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:77.0) Gecko/20100101 Firefox/77.0"
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.3"
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36 Trailer/93.3.8652.5"
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36 Edg/134.0.0"
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36 Edg/131.0.0"
    "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Mobile Safari/537.3"

)
num_user_agents=${#user_agents[@]}
random_index=$(( RANDOM % num_user_agents ))
SELECTED_USER_AGENT="${user_agents[random_index]}"

#### Get a random number of loops
MINRUNS=5
MAXRUNS=20
RUN_TIME=$(( MINRUNS + RANDOM % (MAXRUNS - MINRUNS + 1) ))

#### Get a random source IP address
STARTIP=4
ENDIP=254
RUN_IP=$(( STARTIP + RANDOM % (ENDIP - STARTIP + 1) ))

#### Run a loop of curl
for (( i=0; i<$RUN_TIME; i++ )); do
  echo "Iteration $i"
  curl -A "$SELECTED_USER_AGENT" --interface 192.168.56.$RUN_IP http://192.168.56.2/
  sleep 1
done