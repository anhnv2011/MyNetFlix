//
//  RequestToken.swift
//  NetFlix
//
//  Created by MAC on 7/25/22.
//

import Foundation
struct RequestToken: Codable {
    let success: Bool
    let request_token: String
    let expires_at : String
}
