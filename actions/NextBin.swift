/**
 * Respond to Alexa's NextBin intent
 *
 * Work out if it's a green bit or a black bin week based on if this is an odd or even week.
 * Bin day is Thursday, so if it's Friday or Saturday, then flip the colour.
 * If today is bin day, then change the text to day "today"
 *
 * NOTE: Obviously, this is a hard-coded algorithm that only works for my local council…
 */
func main(args: [String:Any]) -> [String:Any]
{
    let today = Date()
    let calendar = Calendar.current
    let weekOfYear = calendar.component(.weekOfYear, from: today)
    let weekday = calendar.component(.weekday, from: today)

    var colour = "green"
    if weekOfYear % 2 == 0 {
        // even week - so black bin
        colour = "black"
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

    print("Colour for next bin is \(colour)")
    return createAlexaResult("The \(colour) bin is \(next)")
}
