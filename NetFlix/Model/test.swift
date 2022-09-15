//
//  test.swift
//  NetFlix
//
//  Created by MAC on 7/25/22.
//

import Foundation
struct TestAPi:Codable {
    let success: Bool
    let request_token: String?
    let status_code: Int?
    let status_message: String?
}
