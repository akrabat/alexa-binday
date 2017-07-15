func jsonResponse(_ data: [String:Any], code: Int = 200, headers: [String:String] = [:]) -> [String:Any] {
    var headers = headers
    headers["Content-Type"] = "application/json"
    headers["Access-Control-Allow-Origin"] = "*"

    let json = WhiskJsonUtils.dictionaryToJsonString(jsonDict: data) ?? ""
    let body = Data(json.utf8).base64EncodedString()

    return [
        "body": body,
        "statusCode": code,
        "headers": headers,
    ]
}
