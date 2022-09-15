//
//  Login.swift
//  NetFlix
//
//  Created by MAC on 8/19/22.
//

import Foundation
struct Login: Codable {

    let success: Bool
    let statusCode: Int
    let statusMessage: String

    private enum CodingKeys: String, CodingKey {
        case success = "success"
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decode(Bool.self, forKey: .success)
        statusCode = try values.decode(Int.self, forKey: .statusCode)
        statusMessage = try values.decode(String.self, forKey: .statusMessage)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(success, forKey: .success)
        try container.encode(statusCode, forKey: .statusCode)
        try container.encode(statusMessage, forKey: .statusMessage)
    }

}
