/**
 * Some trivially simple functions to send JSON to a web service
 */

import SwiftyJSON
import KituraNet

func putJsonTo(_ url: String, data: [String:Any], headers: [String: String] = [:]) -> (code:Int, json:JSON) {

    var headers = headers
    headers["Content-Type"] = "application/json"

    let jsonBody = WhiskJsonUtils.dictionaryToJsonString(jsonDict: data) ?? ""
    let base64Body = Data(jsonBody.utf8)

    var result: (Int, JSON) = (500, JSON(["error": "unknown"]))

    putTo(url, body: base64Body, headers: headers) { response in
        do {
            let statusCode = response!.statusCode.rawValue
            let str = try response!.readString()!
            let jsonDictionary = JSON.parse(string: str)
            result = (statusCode, jsonDictionary)
        } catch {
            print("Error \(error)")
        }
    }

    return result
}

func putTo(_ url: String, body: Data, headers: [String: String], callback: @escaping ClientRequest.Callback)  {
    var options: [ClientRequest.Options] = [
        .schema(""),
        .method("PUT"),
        .hostname(url),
        .headers(headers)
    ]

    let request = HTTP.request(options, callback: callback)
    request.write(from: body)
    request.end() // send request
}

func postJsonTo(_ url: String, data: [String:Any], headers: [String: String] = [:]) -> (code:Int, json:JSON) {

    var headers = headers
    headers["Content-Type"] = "application/json"

    let jsonBody = WhiskJsonUtils.dictionaryToJsonString(jsonDict: data) ?? ""
    let base64Body = Data(jsonBody.utf8)

    var result: (Int, JSON) = (500, JSON(["error": "unknown"]))

    postTo(url, body: base64Body, headers: headers) { response in
        do {
            let statusCode = response!.statusCode.rawValue
            let str = try response!.readString()!
            let jsonDictionary = JSON.parse(string: str)
            result = (statusCode, jsonDictionary)
        } catch {
            print("Error \(error)")
        }
    }

    return result
}

func postTo(_ url: String, body: Data, headers: [String: String], callback: @escaping ClientRequest.Callback)  {
    var options: [ClientRequest.Options] = [
        .schema(""),
        .method("POST"),
        .hostname(url),
        .headers(headers)
    ]

    let request = HTTP.request(options, callback: callback)
    request.write(from: body)
    request.end() // send request
}

func getJsonFrom(_ url: String, headers: [String: String] = [:]) -> (code:Int, json:JSON) {

    var result: (Int, JSON) = (500, JSON(["error": "unknown"]))

    getFrom(url, headers: ["Accept": "application/json"]) { response in
        do {
            let statusCode = response!.statusCode.rawValue
            let str = try response!.readString()!
            let jsonDictionary = JSON.parse(string: str)
            result = (statusCode, jsonDictionary)
        } catch {
            print("Error \(error)")
        }
    }

    return result
}

func getFrom(_ url: String, headers: [String: String], callback: @escaping ClientRequest.Callback)  {
    var options: [ClientRequest.Options] = [
        .schema(""),
        .method("GET"),
        .hostname(url),
        .headers(headers)
    ]

    let request = HTTP.request(options, callback: callback)
    request.end() // send request
}

func sendDelete(_ url: String, headers: [String: String] = [:]) -> (code:Int, json:JSON) {
    var result: (Int, JSON) = (500, JSON(["error": "unknown"]))

    var options: [ClientRequest.Options] = [
        .schema(""),
        .method("DELETE"),
        .hostname(url),
        .headers(headers)
    ]

    let request = HTTP.request(options) { response in
        do {
            let statusCode = response!.statusCode.rawValue
            let str = try response!.readString()!
            let jsonDictionary = JSON.parse(string: str)
            result = (statusCode, jsonDictionary)
        } catch {
            print("Error \(error)")
        }
    }

    request.end() // send request

    return result
}

