#!/bin/bash

set -x
set -e

network=basic-min2

NEWARK=45.79.174.25
LONDON=139.162.224.204

# clear out any cached state from previous runs
./configure-hosts.sh

ssh root@$NEWARK "cd chutney; CHUTNEY_TOR=/root/tor/src/or/tor ./chutney start networks/$network"
ssh root@$LONDON "tc qdisc del dev eth0 root netem || true; cd chutney; CHUTNEY_TOR=/root/tor/src/or/tor ./chutney start networks/$network"

# minimum sleep before anything useful could happen
sleep 15

# just one run to set up a circuit
ssh root@$LONDON "cd chutney; ./chutney verify networks/$network"

# packet loss
#ssh root@$LONDON "tc qdisc add dev eth0 root netem loss 12.5%"

# 128 MiB
ssh root@$LONDON "cd chutney; CHUTNEY_DATA_BYTES=134217728 ./chutney verify networks/$network"

ssh root@$NEWARK "cd chutney; ./chutney stop networks/$network; killall -9 tor || true"
ssh root@$LONDON "cd chutney; ./chutney stop networks/$network; killall -9 tor || true"
