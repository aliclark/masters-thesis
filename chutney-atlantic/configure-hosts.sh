#!/bin/bash

set -x
set -e

network=basic-min2

NEWARK=45.79.174.25
LONDON=139.162.224.204

ssh root@$NEWARK "./configure-chutney-newark.sh $network 1>&2 && grep -E '^DirAuthority ' chutney/net/nodes/000*/torrc" \
    | ssh root@$LONDON "./configure-chutney-london.sh $network"
