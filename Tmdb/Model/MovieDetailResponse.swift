//
//  MovieDetailResponse.swift
//  Tmdb
//
//  Created by MAC on 10/22/22.
//

import Foundation
struct MovieDetailResponse: Codable {

    let adult: Bool?
    let backdropPath: String?
    let budget: Int?
    let genres: [Genres]?
    let homepage: String?
    let id: Int?
    let imdbId: String?
    let originalLanguage: String?
    let originalTitle: String?
    let overview: String?
    let popularity: Double?
    let posterPath: String?
    let releaseDate: String?
    let revenue: Int?
    let runtime: Int?
    let status: String?
    let tagline: String?
    let title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?

}
