function search_urbandict(query, n) {
    gsub(/ /, "%20", query)
    result = exec_cmd("curl -s 'http://api.urbandictionary.com/v0/define?term=" query "' | jq -r '.list[" n "].definition'")
    if (result != "null" && result != "") {
        return result
    } else {
        return "no definitions found."
    }
}
