# returns lichess rating of `username` in 'category'
function get_lichess_rating(username, category) {
    if (category != "") {
        rating = exec_cmd("curl -s 'https://lichess.org/api/user/" username "' | jq -r .perfs." category ".rating")
        games = exec_cmd("curl -s 'https://lichess.org/api/user/" username "' | jq -r .perfs." category ".games")
        rd = exec_cmd("curl -s 'https://lichess.org/api/user/" username "' | jq -r .perfs." category ".rd")
        prog = exec_cmd("curl -s 'https://lichess.org/api/user/" username "' | jq -r .perfs." category ".prog")

        output = sprintf("%s %s (%s) [N = %s, σ = %s, Δ = %s]", username, category, rating, games, rd, prog)
        return output
    } else {
        return "Please specify category. eg: .l rating <user> rapid"
    }
    # TODO return a summary if category is not supplied
    return "Something went wrong! :("
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

