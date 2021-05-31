# Returns the extract of a wikipedia article
function search_wiki(query) {
    gsub(/ /, "%20", query)
    search_command = "curl -s 'https://en.wikipedia.org/w/rest.php/v1/search/page?q=" query "&limit=5' | jq -r .pages[0].key"
    search = exec_cmd(search_command)
    if (search_command) {
        get_command = "curl -s 'https://en.wikipedia.org/api/rest_v1/page/summary/" search "' | jq -r .extract"
        extract = exec_cmd(get_command)
        if (extract ~ /may refer to:$/) {
            return "Ambigious query"
        } else if (extract == "null") {
            return "No results found! :("
        }
        else {
            return extract
        }
    }
    return "No results found! :("
}
