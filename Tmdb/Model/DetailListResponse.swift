//
//  DetailListResponse.swift
//  Tmdb
//
//  Created by MAC on 10/27/22.
//

import Foundation

struct DetailListResponse: Codable {

    let createdBy: String?
    let description: String?
    let favoriteCount: Int?
    let id: String?
    let items: [Film]
    let itemCount: Int?
    let iso6391: String?
    let name: String?
    let posterPath: String?

}
