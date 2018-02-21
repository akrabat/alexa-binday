/**
 * Respond to Alexa's BinDay skill
 *
 * This is a router action that will check the application id and then invoke the intent action
 */
func main(args: [String:Any]) -> [String:Any]
{
    // check application id
    guard
        let session = args["session"] as? [String:Any],
        let application = session["application"] as? [String:Any],
        let applicationId = application["applicationId"] as? String
    else {
        print("Error: Could not find applicationId");
        return ["problem": "Could not find applicationId"];
    }

    if (applicationId != getSetting("application_id")) {
        print("Error: Wrong applicationId.\nExpected: \(getSetting("application_id"))\nReceived: \(applicationId)");
        return ["problem": "Wrong applicationId"];
    }

    let env = ProcessInfo.processInfo.environment

    // route
    var intentName = "NextBin"
    var slots: [String:String] = [:]
    if
        let request = args["request"] as? [String:Any],
        let intent = request["intent"] as? [String:Any]
    {
        // Found intent dictionary. if we didn't find it, then we use the defaults set up earlier
        print("Found intent")

        intentName = intent["name"] as? String ?? intentName
        if let intentSlots = intent["slots"] as? [String:Any] {
            for (name, intentItem) in intentSlots {
                let item = intentItem as! [String:String]
                for (_, value) in item {
                    slots[name] = value
                }
            }
        }
    }

    // try and invoke the intent action
    print("Intent is \(intentName).")
    switch (intentName)
    {
        case "NextBin":
            return nextBin(args: slots)

        default:
            return createAlexaResult("I'm sorry, I don't know what to do with \(intentName)")
    }
    // let invocationResult = Whisk.invoke(actionNamed: actionName, withParameters: slots)
}

func nextBin(args: [String:Any]) -> [String:Any]
{
    let today = Date()
    let calendar = Calendar.current
    let weekOfYear = calendar.component(.weekOfYear, from: today)
    let weekday = calendar.component(.weekday, from: today)

    var colour = "black"
    if weekOfYear % 2 == 0 {
        // even week - so black bin
        colour = "green"
    }

    if (weekday > 5) {
        // it's after Thursday so we need to swap
        if (colour == "black") {
            colour = "green"
        } else {
            colour = "black"
        }
    }

    var next = "this Thursday"
    if weekday == 4 {
        next = "tomorrow"
    } else if weekday == 5 {
        next = "today"
    } else if weekday == 0 || weekday > 5 {
        next = "<prosody pitch=\"low\">next</prosody> Thursday" // Stop Alexa raising her pitch on "next" before a day name
    }

    print("The \(colour) bin is \(next)")
    return createAlexaResult("The \(colour) bin is \(next)")
}
