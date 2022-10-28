//
//  SessionId.swift
//  Tmdb
//
//  Created by MAC on 7/25/22.
//

import Foundation
//struct SessionId:Codable {
//    let success: Bool
//    let session_id: String
//}

import SwiftyJSON

struct SessionId {

    var success: Bool?
    var sessionId: String?

    init(_ json: JSON) {
        success = json["success"].boolValue
        sessionId = json["session_id"].stringValue
    }

}
