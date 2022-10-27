//
//  DetailFilm.swift
//  NetFlix
//
//  Created by MAC on 9/29/22.
//

import Foundation
struct GenresResponse: Codable {

   
    var genres: [Genres]?
    
}

struct Genres: Codable {

    var id: Int?
    var name: String?

}
