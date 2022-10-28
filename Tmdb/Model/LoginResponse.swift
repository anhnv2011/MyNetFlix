//
//  LoginResponse.swift
//  Tmdb
//
//  Created by MAC on 10/18/22.
//

import Foundation
//struct LoginResponse:Codable {
//    let success: Bool
//    let request_token: String?
//    let status_code: Int?
//    let status_message: String?
//}
import SwiftyJSON

struct LoginResponse {

    var success: Bool?
    var requestToken: String?
    var statusCode: Int?
    var statusMessage: String?

    init(_ json: JSON) {
        success = json["success"].boolValue
        requestToken = json["request_token"].stringValue
        statusCode = json["status_code"].intValue
        statusMessage = json["status_message"].stringValue
    }

}
