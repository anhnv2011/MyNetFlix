//
//  ListResponse.swift
//  Tmdb
//
//  Created by MAC on 10/3/22.
//

import Foundation
import SwiftyJSON
struct ListResponse {

    let page: Int?
    let results: [Lists]?
    let totalPages: Int?
    let totalResults: Int?

    init(_ json: JSON) {
        page = json["page"].intValue
        results = json["results"].arrayValue.map { Lists($0) }
        totalPages = json["total_pages"].intValue
        totalResults = json["total_results"].intValue
    }

}
struct Lists {

    let description: String?
    let favoriteCount: Int?
    let id: Int?
    let itemCount: Int?
    let iso6391: String?
    let listType: String?
    let name: String?
    let posterPath: Any?

    init(_ json: JSON) {
        description = json["description"].stringValue
        favoriteCount = json["favorite_count"].intValue
        id = json["id"].intValue
        itemCount = json["item_count"].intValue
        iso6391 = json["iso_639_1"].stringValue
        listType = json["list_type"].stringValue
        name = json["name"].stringValue
        posterPath = json["poster_path"]
    }

}
