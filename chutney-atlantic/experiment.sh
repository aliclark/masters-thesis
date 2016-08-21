#!/bin/bash

set -x
set -e

branch=$1
network=$2
loss=$3
extra=$4

NEWARK=45.79.174.25

echo experiment version: 1 branch: $branch network: $network loss: $loss extra: $extra

# clear out any cached state from previous runs
./configure-hosts.sh $network

cd $HOME/chutney

ssh root@$NEWARK "cd chutney; CHUTNEY_TOR=/root/$branch/src/or/tor ./chutney start networks/$network"

tc qdisc del dev eth0 root netem || true
CHUTNEY_TOR=/root/$branch/src/or/tor ./chutney start networks/$network

# minimum sleep before anything useful could happen
sleep 15

# just one run to set up a circuit
./chutney verify networks/$network

# packet loss
if [ "$loss" ]; then
    tc qdisc add dev eth0 root netem loss $loss
fi

# 64 MiB
CHUTNEY_DATA_BYTES=67108864 ./chutney verify networks/$network

# TODO: put these in a trap exit
ssh root@$NEWARK "cd chutney; ./chutney stop networks/$network; killall -9 tor || true"
tc qdisc del dev eth0 root netem || true
./chutney stop networks/$network
killall -9 tor || true
