#!/bin/bash

set -x
set -e

NEWARK=45.79.174.25
LONDON=139.162.224.204

scp configure-chutney-newark.sh root@$NEWARK:
scp configure-chutney-london.sh root@$LONDON:

ssh root@$NEWARK "sed 's/Client.getN(1)/Client.getN(2)/' chutney/networks/basic-min >chutney/networks/basic-min2; sed 's/Client.getN(1)/Client.getN(3)/' chutney/networks/basic-min >chutney/networks/basic-min3"
ssh root@$LONDON "sed 's/Client.getN(1)/Client.getN(2)/' chutney/networks/basic-min >chutney/networks/basic-min2; sed 's/Client.getN(1)/Client.getN(3)/' chutney/networks/basic-min >chutney/networks/basic-min3"
