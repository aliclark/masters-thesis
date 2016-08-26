#!/bin/bash

set -x
set -e

network=$1

killall -9 tor || true

# Reset loss settings
tc qdisc del dev eth0 root netem || true

cd $HOME/chutney

CHUTNEY_LISTEN_ADDRESS=$(dig +short myip.opendns.com @resolver1.opendns.com) CHUTNEY_TOR_GENCERT=/root/tor-0.2.7.6/src/tools/tor-gencert CHUTNEY_TOR=/root/tor-0.2.7.6/src/or/tor ./chutney configure networks/$network
sed -i 's/^Log/#Log/' net/nodes/*/torrc

# Point all nodes to the authorities provided, and not the ones generated above
while read line; do
  sed -i "s/^$(echo $line | awk '{print $1" "$2}') .*/$line/" net/nodes/*/torrc
done

# No authorities this side - ensures we use them as Guard,Middle
# across the pond
sed -i 's/:700/:666/' net/nodes/*a/torrc
