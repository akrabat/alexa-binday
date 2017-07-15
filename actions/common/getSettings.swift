/**
 * Get the settings from the WHISK_INPUT environment variable as this contains the
 * args dictionary that's passed into main()
 */
func getSetting(_ key: String) -> String {
    let env = ProcessInfo.processInfo.environment
    guard
        let whiskInput = env["WHISK_INPUT"],
        let dataFromString = whiskInput.data(using: .utf8)
    else {
        dump("'WHISK_INPUT' missing in getSetting()!")
        exit(-1)
    }

    let jsonArgs = JSON(data: dataFromString)

    if let value = jsonArgs["settings"][key].string {
        return value
    }

    dump("Configuration parameter '\(key)' missing in 'settings'")
    exit(-1)
}


/**
 * The base path is all of the __OW_ACTION_NAME before the action's specific name
 * e.g. /guest/flashcards/getCard => /guest/flashcard/
 */
func getFullActionName(for action: String) -> String
{
    let env = ProcessInfo.processInfo.environment
    let fullName : String = env["__OW_ACTION_NAME"] ?? ""

    if let index = fullName.range(of: "/", options: .backwards)?.lowerBound {
        return fullName.substring(to: fullName.index(after: index)) + action
    }

    return ""
}
