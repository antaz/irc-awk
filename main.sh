#!/bin/bash

set -euo pipefail

coproc CLIENT {
    while :; do openssl s_client --connect "irc.libera.chat:6697" -quiet; done
}

<&"${CLIENT[0]}" gawk -f main.awk -v "IRC_NICKNAME=$IRC_NICKNAME" -v "IRC_CHANNEL=$IRC_CHANNEL" >&"${CLIENT[1]}"
