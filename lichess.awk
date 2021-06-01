# returns lichess rating of `username` in 'category'
function get_lichess_rating(username, category) {
    if (category ~ /^(rapid)|(blitz)|(bullet)|(ultrabullet)|(puzzle)$/) {
        rating = exec_cmd("curl -s 'https://lichess.org/api/user/" username "' | jq -r .perfs." category ".rating")
        games = exec_cmd("curl -s 'https://lichess.org/api/user/" username "' | jq -r .perfs." category ".games")
        rd = exec_cmd("curl -s 'https://lichess.org/api/user/" username "' | jq -r .perfs." category ".rd")
        prog = exec_cmd("curl -s 'https://lichess.org/api/user/" username "' | jq -r .perfs." category ".prog")

        if (rating) {
            output = sprintf("%s %s (%s) [N = %s, σ = %s, Δ = %s]", username, category, rating, games, rd, prog)
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

