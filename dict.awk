function search_urbandict(query, n,    result) {
    # url encoding similar to the wiki search function
    query = sanitize_url(query)
    result = exec_cmd("curl -s 'https://api.urbandictionary.com/v0/define?term=" query "' | jq -r '.list[" n "].definition'")
    if (result != "null" && result != "") {
        return result
    } else {
        return "no definitions found."
    }
}
