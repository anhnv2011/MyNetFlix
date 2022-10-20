////
////  Movie.swift
////  NetFlix
////
////  Created by MAC on 6/27/22.
////
//
//import Foundation
//struct Film:Codable {
//    var adult:Bool?
//    var id: Int
//    var media_type: String?
//    var title: String?
//    var original_name: String?
//    var original_language: String?
//    var original_title: String?
//    var overview: String?
//    var popularity:Double?
//    var poster_path: String
//    var release_date: String?
//    var video: Bool?
//    var vote_average: Double?
//    var vote_count: Int?
//    var genre_ids: [Int]?
//
//    var rating: Double?  // Chir có khi goi gọi rate list
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

    var adult: Bool?
        var backdropPath: String?
        var id: Int?
        var originalLanguage: String?
        var originalName: String?
        var originalTitle: String?
        var overview: String?
        var posterPath: String?
        var mediaType: String?
        var genreIds: [Int]?
        var popularity: Double?
        var releaseDate: String?
        var firstAirDate: String?
        var voteAverage: Double?
        var voteCount: Int?
        var originCountry: [String]?

        private enum CodingKeys: String, CodingKey {
            case adult = "adult"
            case backdropPath = "backdrop_path"
            case id = "id"
            case originalLanguage = "original_language"
            case originalName = "original_name"
            case originalTitle = "original_title"
            case overview = "overview"
            case posterPath = "poster_path"
            case mediaType = "media_type"
            case genreIds = "genre_ids"
            case popularity = "popularity"
            case releaseDate = "release_date"
            case firstAirDate = "first_air_date"
            case voteAverage = "vote_average"
            case voteCount = "vote_count"
            case originCountry = "origin_country"
        }

//        init(from decoder: Decoder) throws {
//            let values = try decoder.container(keyedBy: CodingKeys.self)
//            adult = try values.decodeIfPresent(Bool.self, forKey: .adult)
//            backdropPath = try values.decodeIfPresent(String.self, forKey: .backdropPath)
//            id = try values.decodeIfPresent(Int.self, forKey: .id)
//            originalLanguage = try values.decodeIfPresent(String.self, forKey: .originalLanguage)
//            originalName = try values.decodeIfPresent(String.self, forKey: .originalName)
//            originalTitle = try values.decodeIfPresent(String.self, forKey: .originalTitle)
//            overview = try values.decodeIfPresent(String.self, forKey: .overview)
//            posterPath = try values.decodeIfPresent(String.self, forKey: .posterPath)
//            mediaType = try values.decodeIfPresent(String.self, forKey: .mediaType)
//            genreIds = try values.decodeIfPresent([Int].self, forKey: .genreIds)
//            popularity = try values.decodeIfPresent(Double.self, forKey: .popularity)
//            releaseDate = try values.decodeIfPresent(String.self, forKey: .releaseDate)
//            firstAirDate = try values.decodeIfPresent(String.self, forKey: .firstAirDate)
//            voteAverage = try values.decodeIfPresent(Double.self, forKey: .voteAverage)
//            voteCount = try values.decodeIfPresent(Int.self, forKey: .voteCount)
//            originCountry = try values.decodeIfPresent([String].self, forKey: .originCountry)
//        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeIfPresent(adult, forKey: .adult)
            try container.encodeIfPresent(backdropPath, forKey: .backdropPath)
            try container.encodeIfPresent(id, forKey: .id)
            try container.encodeIfPresent(originalLanguage, forKey: .originalLanguage)
            try container.encodeIfPresent(originalName, forKey: .originalName)
            try container.encodeIfPresent(overview, forKey: .overview)
            try container.encodeIfPresent(posterPath, forKey: .posterPath)
            try container.encodeIfPresent(mediaType, forKey: .mediaType)
            try container.encodeIfPresent(genreIds, forKey: .genreIds)
            try container.encodeIfPresent(popularity, forKey: .popularity)
            try container.encodeIfPresent(releaseDate, forKey: .releaseDate)
            try container.encodeIfPresent(firstAirDate, forKey: .firstAirDate)
            try container.encodeIfPresent(voteAverage, forKey: .voteAverage)
            try container.encodeIfPresent(voteCount, forKey: .voteCount)
            try container.encodeIfPresent(originCountry, forKey: .originCountry)
        }

    }
