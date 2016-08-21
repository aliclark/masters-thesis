#!/bin/bash

set -x
set -e

network=$1

killall -9 tor || true

cd $HOME/chutney

CHUTNEY_LISTEN_ADDRESS=$(dig +short myip.opendns.com @resolver1.opendns.com) CHUTNEY_TOR_GENCERT=/root/tor-0.2.7.6/src/tools/tor-gencert CHUTNEY_TOR=/root/tor-0.2.7.6/src/or/tor ./chutney configure networks/$network
sed -i 's/^Log/#Log/' net/nodes/*/torrc

# No exits this side - ensures we use the exit relay across the pond
# No clients needed here either
sed -i "s/:700/:666/" net/nodes/*{r,c}/torrc

echo 'ExitPolicy reject *:*' | tee -a net/nodes/*a/torrc
