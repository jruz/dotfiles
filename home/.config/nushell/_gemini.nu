def build-payload [text: string]: nothing -> record {
    let prompt = $"I am using Nushell what is the correct command to do: ($text) \n Reply only with the command in raw form no markdown."
    {
        contents: [
            {
                parts: [
                    {text: $prompt}
                ]
            }
        ]
    }
}

def fetch-response [payload: record]: nothing -> record {
    let api_key = $env.GEMINI_API_KEY?
    if ($api_key | is-empty) {
        error make {msg: "GEMINI_API_KEY environment variable not set"}
    }
    let url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-3-flash-preview:generateContent"
    try {
        http post --headers [
            "x-goog-api-key" $api_key
            "Content-Type" "application/json"
        ] $url ($payload | to json)
    } catch {|failure|
        error make {msg: $"API request failed: ($failure.msg)"}
    }
}

def response-text [response: record]: nothing -> string {
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
    try {
        $response.candidates.0.content.parts.0.text
    } catch {
        error make {msg: "Failed to extract text from response"}
    }
}

export def main [prompt?: string]: [nothing -> string, string -> string] {
    let stdin = $in
    let input_text = match $prompt {
        null => {
            if $stdin == null {
                error make {msg: "A prompt or pipeline input is required"}
            }
            $stdin
        }
        _ => $prompt
    }
    print --no-newline " "
    let payload = (build-payload $input_text)
    let response = (fetch-response $payload)
    response-text $response
}
