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
        print("Found intent dictionary")

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

    // create the action name to invoke by taking __OW_ACTION_NAME and replacing the last segment
    // with the intent name
    let thisActionName = env["__OW_ACTION_NAME"] ?? ""
    var parts = thisActionName.components(separatedBy: "/")
    parts.removeLast()
    parts.append(intentName)
    let actionName = parts.joined(separator: "/")

    // try and invoke the intent action
    print("Intent is \(intentName); invoking \(actionName)")
    let invocationResult = Whisk.invoke(actionNamed: actionName, withParameters: slots)
    
    // extract result dictionary and success flag from the invocationResult and return the
    // result if success is true
    if
        let response = invocationResult["response"] as? [String:Any],
        let result = response["result"] as? [String:Any],
        let success = response["success"] as? Bool,
        success == true
    {
        return result
    }

    // failed to run the intent action or it was not successful
    return createAlexaResult("Sorry, but I was unable to do this at this time")
}
