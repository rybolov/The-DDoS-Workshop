#!/bin/bash

tc qdisc add dev eth1 root handle 1: tbf rate 2mbit latency 1ms burst 1000
modprobe ifb numifbs=1
ip link set dev ifb0 up
tc qdisc add dev eth1 ingress
tc filter add dev eth1 parent ffff: protocol ip u32 match u32 0 0 action mirred egress redirect dev ifb0
tc qdisc add dev ifb0 root handle 1: tbf rate 2mbit latency 1ms burst 1000