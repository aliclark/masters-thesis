#!/bin/bash

set -x
set -e

branch=$1
network=$2
loss=$3
extra=$4

NEWARK=45.79.174.25

echo experiment version: 2 branch: $branch network: $network loss: $loss extra: $extra

# clear out any cached state from previous runs
./configure-hosts.sh $network

cd $HOME/chutney

ssh root@$NEWARK "cd chutney; CHUTNEY_TOR=/root/$branch/src/or/tor ./chutney start networks/$network"

tc qdisc del dev eth0 root netem || true
CHUTNEY_TOR=/root/$branch/src/or/tor ./chutney start networks/$network

# minimum sleep before anything useful could happen
sleep 45

# just one run to set up a circuit
./chutney verify networks/$network

# packet loss
if [[ "$loss" && "$loss" != "0" && "$loss" != "0%" && "$loss" != "0.0%" && "$loss" != "0.000000%" ]]; then
    ssh root@$NEWARK "tc qdisc add dev eth0 root netem loss $loss"
fi

# clear network stats
nstat -r >/dev/null

# 64 MiB
CHUTNEY_DATA_BYTES=67108864 ./chutney verify networks/$network

# dump network stats difference
nstat

# get a rough feel for how cpu intensive it was
uptime

# TODO: put these in a trap exit
ssh root@$NEWARK "tc qdisc del dev eth0 root netem || true; cd chutney; ./chutney stop networks/$network; killall -9 tor || true"
./chutney stop networks/$network
killall -9 tor || true

echo fin
