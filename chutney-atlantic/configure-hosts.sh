#!/bin/bash

set -x
set -e

NEWARK=45.79.174.25
LONDON=139.162.224.204

scp configure-chutney-newark.sh root@$NEWARK:
scp configure-chutney-london.sh root@$LONDON:

ssh root@$NEWARK './configure-chutney-newark.sh'
ssh root@$NEWARK 'grep -E "^DirAuthority " chutney/net/nodes/000a/torrc' | ssh root@$LONDON './configure-chutney-london.sh'
