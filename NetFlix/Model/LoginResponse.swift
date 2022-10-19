//
//  LoginResponse.swift
//  NetFlix
//
//  Created by MAC on 10/18/22.
//

import Foundation
struct LoginResponse:Codable {
    let success: Bool
    let request_token: String?
    let status_code: Int?
    let status_message: String?
}
