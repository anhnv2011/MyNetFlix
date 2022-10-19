////
////  Movie.swift
////  NetFlix
////
////  Created by MAC on 6/27/22.
////
//
//import Foundation
//struct Film:Codable {
//    let adult:Bool?
//    let id: Int
//    var media_type: String?
//    let title: String?
//    let original_name: String?
//    let original_language: String?
//    let original_title: String?
//    let overview: String?
//    let popularity:Double?
//    let poster_path: String
//    let release_date: String?
//    let video: Bool?
//    let vote_average: Double?
//    let vote_count: Int?
//    let genre_ids: [Int]?
//
//    let rating: Double?  // Chir có khi goi gọi rate list
//
//}
//
//  Results.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on October 19, 2022
//
import Foundation

struct Film: Codable {

    let adult: Bool
    let backdropPath: String
    let id: Int
    let title: String
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let posterPath: String
    let mediaType: String
    let genreIds: [Int]
    let popularity: Double
    let releaseDate: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    private enum CodingKeys: String, CodingKey {
        case adult = "adult"
        case backdropPath = "backdrop_path"
        case id = "id"
        case title = "title"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview = "overview"
        case posterPath = "poster_path"
        case mediaType = "media_type"
        case genreIds = "genre_ids"
        case popularity = "popularity"
        case releaseDate = "release_date"
        case video = "video"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        adult = try values.decode(Bool.self, forKey: .adult)
        backdropPath = try values.decode(String.self, forKey: .backdropPath)
        id = try values.decode(Int.self, forKey: .id)
        title = try values.decode(String.self, forKey: .title)
        originalLanguage = try values.decode(String.self, forKey: .originalLanguage)
        originalTitle = try values.decode(String.self, forKey: .originalTitle)
        overview = try values.decode(String.self, forKey: .overview)
        posterPath = try values.decode(String.self, forKey: .posterPath)
        mediaType = try values.decode(String.self, forKey: .mediaType)
        genreIds = try values.decode([Int].self, forKey: .genreIds)
        popularity = try values.decode(Double.self, forKey: .popularity)
        releaseDate = try values.decode(String.self, forKey: .releaseDate)
        video = try values.decode(Bool.self, forKey: .video)
        voteAverage = try values.decode(Double.self, forKey: .voteAverage)
        voteCount = try values.decode(Int.self, forKey: .voteCount)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(adult, forKey: .adult)
        try container.encode(backdropPath, forKey: .backdropPath)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(originalLanguage, forKey: .originalLanguage)
        try container.encode(originalTitle, forKey: .originalTitle)
        try container.encode(overview, forKey: .overview)
        try container.encode(posterPath, forKey: .posterPath)
        try container.encode(mediaType, forKey: .mediaType)
        try container.encode(genreIds, forKey: .genreIds)
        try container.encode(popularity, forKey: .popularity)
        try container.encode(releaseDate, forKey: .releaseDate)
        try container.encode(video, forKey: .video)
        try container.encode(voteAverage, forKey: .voteAverage)
        try container.encode(voteCount, forKey: .voteCount)
    }

}
