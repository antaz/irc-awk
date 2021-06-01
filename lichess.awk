# returns lichess rating of `username` in 'category'
function get_lichess_rating(username, category) {
    if (category ~ /^(rapid)|(blitz)|(bullet)|(ultrabullet)|(puzzle)$/) {

        output = exec_cmd("curl -s 'https://lichess.org/api/user/" username "' | jq -rc '[.perfs." category ".rating, .perfs." category ".games, .perfs." category ".rd, .perfs." category ".prog]'")

        if (output) {
            gsub(/[\[\]]/, "", output)
            split(output, a, ",")

            output = sprintf("%s %s (%s) [N = %s, σ = %s, Δ = %s]", username, category, a[1], a[2], a[3], a[4])
            return output
        } else {
            return "User not found!"
        }
    } else {
        return "Specify a valid category: (rapid, blitz, bullet, ultrabullet, puzzle)"
    }
}

# returns tv url of 'username'
function get_lichess_tv(username) {
    command = "curl -s 'https://lichess.org/api/user/" username "' | jq -r .url"
    result = exec_cmd(command)
    if (result) {
        return result "/tv"
    } else {
        return "Something went wrong! :("
    }
}

