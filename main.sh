#! /bin/bash

set -euo pipefail

coproc GAWK { 
    gawk -f main.awk -v "IRC_NICKNAME=$IRC_NICKNAME" -v "IRC_CHANNEL=$IRC_CHANNEL" 
}

<&"${GAWK[0]}" openssl s_client --connect "irc.libera.chat:6697" -quiet >&"${GAWK[1]}"
