#!/bin/bash

set -x
set -e

NEWARK=45.79.174.25
LONDON=139.162.224.204

apt-get update -y
#apt-get upgrade -y

apt-get install -y ethtool

ip6tables -F INPUT
ip6tables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
ip6tables -A INPUT -i lo -j ACCEPT
ip6tables -P INPUT DROP
ip6tables -P FORWARD DROP

iptables -F INPUT
iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -s $LONDON -j ACCEPT
iptables -P INPUT DROP
iptables -P FORWARD DROP

for i in $(seq 1 8); do
    sed "s/Client.getN(1)/Client.getN($i)/" chutney/networks/basic-min >chutney/networks/basic-min-$i
done
