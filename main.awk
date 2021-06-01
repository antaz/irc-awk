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
                            send_msg($3, "Specify username: .l tv <username>")
                        }
                    break
                    case "rating":
                        if ($6) {
                            if ($7) {
                                send_msg($3, get_lichess_rating($6, $7))
                            } else {
                                send_msg($3, "Specify category: .l rating <username> <category>")
                            }
                        } else {
                            send_msg($3, "Specify username: .l rating <username> <category>")
                        }
                    break
                    default:
                    break
                }
            } else {
                send_msg($3, "Lichess command: .l <rating|tv> <username> <category>")
            }
        break
        case ":.d":
            # TODO implement dictionary capability
        break
        case ":.w":
            if ($5) {
                send_msg($3, search_wiki(collect(5)))
            } else {
                send_msg($3, "Wikipedia command: .w <query>")
            }
        break
        default:
            send_msg($3, "Invalid command!")
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
