//
//  Authentication.swift
//  NetFlix
//
//  Created by MAC on 7/25/22.
//

import Foundation
struct Authentication: Codable {
    let expires_at: String
    let request_token: String
    let success: Bool
}
