func jsonResponse(_ data: [String:Any], code: Int = 200, headers: [String:String] = [:]) -> [String:Any] {
    var headers = headers
    headers["Content-Type"] = "application/json"

    return [
        "body": data,
        "statusCode": code,
        "headers": headers,
    ]
}
