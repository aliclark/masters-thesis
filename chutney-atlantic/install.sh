#!/bin/bash

set -x
set -e

NEWARK=45.79.174.25
LONDON=139.162.224.204


# TODO: all the stuff that comes before


scp configure-chutney-newark.sh root@$NEWARK:
scp configure-chutney-london.sh root@$LONDON:

for i in $(seq 1 8); do
    ssh root@$NEWARK "sed 's/Client.getN(1)/Client.getN($i)/' chutney/networks/basic-min >chutney/networks/basic-min-$i"
    ssh root@$LONDON "sed 's/Client.getN(1)/Client.getN($i)/' chutney/networks/basic-min >chutney/networks/basic-min-$i"
done
