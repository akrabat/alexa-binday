/**
 * Create a dictionay in the format Alexa expects when returning a message to be spoken
 */
func createAlexaResult(_ msg: String) -> [String:Any]
{
    return [
        "response" : [
            "shouldEndSession" : true,
            "outputSpeech" : [
              "type" : "SSML",
              "ssml" : "<speak>\(msg)</speak>",
            ],
        ],
        "version" : "1.0",
    ]
}
