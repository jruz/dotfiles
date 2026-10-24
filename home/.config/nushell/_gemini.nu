def build_payload [text: string] {
    let prompt = $"I am using Nushell what is the correct command to do: ($text) \n Reply only with the command in raw form no markdown."

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

export def main [prompt?: string] {
    let model = "gemini-3-flash-preview"

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

    print --no-newline " "

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
