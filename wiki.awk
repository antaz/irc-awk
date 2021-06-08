# Returns the extract of a wikipedia article
function search_wiki(query, lang_code) {
    # url encoding
    gsub(/ /, "%20", query) # replace space with %20 
    gsub(/'/, "%27", query) # replace single quote with %27
    search_command = "curl -s 'https://" lang_code ".wikipedia.org/w/rest.php/v1/search/page?q=" query "&limit=5' | jq -r .pages[0].key"
    search = exec_cmd(search_command)
    if (search_command) {
        get_command = "curl -s 'https://" lang_code ".wikipedia.org/api/rest_v1/page/summary/" search "' | jq -r .extract"
        extract = exec_cmd(get_command)
        if (extract ~ /may refer to:/) {
            return "ambigious query"
        } else if (extract == "null") {
            return "no results found!"
        }
        else {
            return extract
        }
    }
    return "no results found!"
}
