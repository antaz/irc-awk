function search_urbandict(query) {
    result = exec_cmd("curl -s 'http://api.urbandictionary.com/v0/define?term=" query "' | jq -r '.list[0].definition'")
    if (result != "null") {
        return result
    } else {
        return "no definitions found."
    }
}
