function search_urbandict(query, n) {
    # url encoding similar to the wiki search function
    gsub(/ /, "%20", query)
    gsub(/'/, "%27", query)
    cmd = "curl -s 'http://api.urbandictionary.com/v0/define?term=" query "' | jq -r '.list[" n "].definition'"
    write(cmd)
    result = exec_cmd(cmd)
    if (result != "null" && result != "") {
        return result
    } else {
        return "no definitions found."
    }
}
