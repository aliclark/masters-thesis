#!/bin/bash

set -x
set -e

cd chutney
CHUTNEY_LISTEN_ADDRESS=$(dig +short myip.opendns.com @resolver1.opendns.com) CHUTNEY_TOR_GENCERT=/root/tor-0.2.7.6/src/tools/tor-gencert CHUTNEY_TOR=/root/tor-0.2.7.6/src/or/tor ./chutney configure networks/basic-min
sed -i 's/^Log/#Log/' net/nodes/*/torrc

# No exits this side - ensures we use the exit relay across the pond
sed -i "s/:700/:666/" net/nodes/*r/torrc

echo 'ExitPolicy reject *:*' | tee -a net/nodes/*a/torrc
