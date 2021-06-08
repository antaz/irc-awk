#! /bin/awk -f

@include "lichess"
@include "wiki"
@include "dict"

BEGIN {
    identify(IRC_NICKNAME)
}

# TODO logging capability: for now only printing lines
{
    sub(/\r$/, "")
    read()
}

# Identified successfully so JOIN channel
/376/ {
    write("JOIN " IRC_CHANNEL)
}

# Repond to PING requests
/PING/ {
    write("PONG")
}

# Recieved message from a channel
/^[^ ]+ PRIVMSG #[^ ]+ :\./ {
    sub(/\r/, "")
    switch($4) {
        case ":.l":
            if ($5) {
                switch($5) {
                    case "tv":
                        if ($6) {
                            send_msg($3, get_lichess_tv($6))
                        } else {
                            send_msg($3, "specify username: .l tv <username>")
                        }
                    break
                    case "rating":
                        if ($6) {
                            if ($7) {
                                send_msg($3, get_lichess_rating($6, $7))
                            } else {
                                send_msg($3, get_lichess_rating($6, "rapid"))
                            }
                        } else {
                            send_msg($3, "specify username: .l rating <username> <category>")
                        }
                    break
                    case "alias":
                        if ($6) {
                            if ($7) {
                                send_msg($3, add_lichess_alias($6, $7))
                            } else {
                                send_msg($3, "add alias: .l alias <nick> <alias>")
                            }
                        } else {
                                send_msg($3, "add alias: .l alias <nick> <alias>")
                        }
                    default:
                    break
                }
            } else {
                send_msg($3, "lichess command: .l <rating | tv | alias> <username> <category>")
            }
        break
        case ":.ud":
            if ($5) {
                if ($6 && ($5 ~ /^[1-9]$/)) {
                    send_msg($3, search_urbandict(collect(6), $5-1))
                } else {
                    send_msg($3, search_urbandict(collect(5), 0))
                }
            } else {
                send_msg($3, "urban dictionary command: .ud [def_number] <query>")
            }
        break
        case ":.w":
            if ($5) {
                if ($5 ~ /^..$/) {
                    if ($6) {
                        send_msg($3, search_wiki(collect(6), $5))
                    } else {
                        send_msg($3, "wikipedia command: .w [lang_code] <query>")
                    }
                } else {
                    send_msg($3, search_wiki(collect(5), "en"))
                }
            } else {
                send_msg($3, "wikipedia command: .w [lang_code] <query>")
            }
        break
        case ":.h":
            send_msg($3, "supported commands: .l (lichess), .w (wikipedia), .ud (urban dictionary).")
        default:
        break
            
    }
}


# prints current line
function read() {
    printf "<<< %s\n", $0 > "/dev/stderr"
}

# prints and sends `line` to network
function write(line) {
    printf ">>> %s\n", line > "/dev/stderr"
    printf "%s\r\n", line
    fflush()
}

# identifying via services (or just setting NICK and USER for now)
function identify(nick) {
    write("NICK " nick)
    write("USER " nick " * " nick " " nick)
}

# collect fields from n to NF in a string TODO need to come up with a better name for this
function collect(n) {
    out = $n
    for(i=n+1;i<=NF;i++){out=out" "$i}
    return out
}

# Executing a command and returing its getline output
function exec_cmd(command) {
    result = ""
    command |& getline result
    close(command)
    return result
}

# sends a `message` to a specific `target` (channel or user)
function send_msg(target, message) {
    write("PRIVMSG " target " :" message)
}
