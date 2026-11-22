export def "http post" [url: string, body: string, --content-type: string]: nothing -> nothing {
    let payload = if $content_type != null and $content_type == 'application/json' {
        $body | from json
    } else {
        $body
    }
    print ({url: $url, body: $payload} | to nuon)
}

def main []: nothing -> nothing {
    source ../home/.local/bin/,notify
    main all --title "Café backup" --message "Backup finished."
}
