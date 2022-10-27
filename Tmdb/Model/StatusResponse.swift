//
//  StatusResponse.swift
//  Tmdb
//
//  Created by MAC on 9/28/22.
//

import Foundation
struct StatusResponse: Codable {

    let success: Bool?
    let status_code: Int?
    let status_message: String?

}
