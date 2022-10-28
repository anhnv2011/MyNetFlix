//
//  RequestToken.swift
//  Tmdb
//
//  Created by MAC on 7/25/22.
//

import Foundation
//struct RequestToken: Codable {
//    let success: Bool
//    let request_token: String
//    let expires_at : String
//}
import SwiftyJSON

struct RequestToken {

    let success: Bool?
    let expiresAt: String?
    let requestToken: String?

    init(_ json: JSON) {
        success = json["success"].boolValue
        expiresAt = json["expires_at"].stringValue
        requestToken = json["request_token"].stringValue
    }

}
