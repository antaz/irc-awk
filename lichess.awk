# returns lichess rating of `username` in 'category'
function get_lichess_rating(username, category) {
    username = sanitize_url(username)
    if (category ~ /^(classical)|(rapid)|(blitz)|(bullet)|(ultrabullet)|(puzzle)|(correspondence)$/) {
        # check if username is aliased
        output = exec_cmd("jq -r '." username "' alias.json")
        if (output != "null") {
            username = output
        }

        output = exec_cmd("curl -s 'https://lichess.org/api/user/" username "' | jq -rc '[.perfs." category ".rating, .perfs." category ".games, .perfs." category ".rd, .perfs." category ".prog]'")

        if (output) {
            gsub(/[\[\]]/, "", output)
            split(output, a, ",")

            output = sprintf("%s %s (%s) [N = %s, σ = %s, Δ = %s]", username, category, a[1], a[2], a[3], a[4])
            return output
        } else {
            return "user not found!"
        }
    } else {
        return "specify a valid category: (rapid, blitz, bullet, ultrabullet, puzzle)"
    }
}

# returns tv url of 'username'
function get_lichess_tv(username) {
    username = sanitize_url(username)
    command = "curl -s 'https://lichess.org/api/user/" username "' | jq -r .url"
    result = exec_cmd(command)
    if (result != "" && result != "null") {
        return result "/tv"
    } else {
        return "username not found!"
    }
}

# add lichess alias
function add_lichess_alias(username, alias) {
    command = "echo $(cat alias.json | jq '. + {" alias ": \"" username "\"}') > alias.json"
    result = exec_cmd(command)
    if (!result) {
        return "alias " username " -> " alias " successfully added."
    } else {
        return "failed to add alias."
    }
}

function delete_lichess_alias(alias) {
    command = "echo $(cat alias.json | jq 'del(." alias ")') > alias.json"
    result = exec_cmd(command)
    if (!result) {
        return "alias " alias " deleted."
    } else {
        return "failed to delete alias."
    }
    # TODO check if alias exists before deleting 
    # this always succeed
}
