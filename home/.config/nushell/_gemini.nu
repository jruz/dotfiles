def build_payload [text: string] {
    let prompt = $"I am using Nushell whats the commands to do: ($text) \n Reply only with the command in raw form no markdown."

    {
        contents: [
            {
                parts: [
                    {
                        text: $prompt
                    }
                ]
            }
        ]
    }
}

def gemini [prompt?: string] {
    let model = "gemini-2.5-flash-lite"

    let stdin = $in

    let input_text = if ($prompt | is-not-empty) {
        $prompt
    } else {
        $stdin
    }

    let api_key = $env.GEMINI_API_KEY?

    if ($api_key | is-empty) {
        error make {msg: "GEMINI_API_KEY environment variable not set"}
    }

    print -n " "

    let payload = (build_payload $input_text) | to json

    let url = $"https://generativelanguage.googleapis.com/v1beta/models/($model):generateContent"

    let response = try {
        http post --headers [
            "x-goog-api-key" $api_key
            "Content-Type" "application/json"
        ] $url $payload
    } catch { |err|
        error make {msg: $"API request failed: ($err.msg)"}
    }

    if ($response.error? | is-not-empty) {
        error make {msg: $"API returned error: ($response.error.message)"}
    }

    if ($response.candidates? | is-empty) {
        let reason = if ($response.promptFeedback?.blockReason? | is-not-empty) {
            $"Content blocked: ($response.promptFeedback.blockReason)"
        } else {
            "No candidates in response"
        }
        error make {msg: $reason}
    }

    let result = try {
        $response.candidates.0.content.parts.0.text
    } catch {
        error make {msg: "Failed to extract text from response"}
    }

    $result
}

export def test_gemini_with_stdin [] {
    use std assert

    if ($env.GEMINI_API_KEY? | is-empty) {
        print "⚠ Skipping test: GEMINI_API_KEY not set"
        return
    }

    let result = "list files sorted by size" | gemini
    assert ($result | is-not-empty)
    assert ($result | str contains "ls")
}

export def test_gemini_with_arg [] {
    use std assert

    if ($env.GEMINI_API_KEY? | is-empty) {
        print "⚠ Skipping test: GEMINI_API_KEY not set"
        return
    }

    let result = gemini "show current directory"
    assert ($result | is-not-empty)
    assert ($result | str contains "pwd")
}

export def test_gemini_no_api_key [] {
    use std assert

    let original_key = $env.GEMINI_API_KEY?
    hide-env GEMINI_API_KEY

    let result = try {
        "test" | gemini
        false
    } catch {
        true
    }

    assert $result

    if ($original_key | is-not-empty) {
        $env.GEMINI_API_KEY = $original_key
    }
}
