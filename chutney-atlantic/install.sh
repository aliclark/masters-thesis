#!/bin/bash

set -x
set -e

NEWARK=45.79.174.25
LONDON=139.162.224.204

scp install-newark.sh configure-chutney-newark.sh root@$NEWARK:
scp install-london.sh configure-chutney-london.sh root@$LONDON:

ssh root@$NEWARK ./install-newark.sh
ssh root@$LONDON ./install-london.sh
