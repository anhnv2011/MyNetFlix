//
//  TVDetailResponse.swift
//  NetFlix
//
//  Created by MAC on 10/22/22.
//

import Foundation
struct TVDetailResponse: Codable {

    let adult: Bool?
    let backdropPath: String?
    let createdBy: [CreatedBy]?
    let episodeRunTime: [Int]?
    let firstAirDate: String?
    let genres: [Genres]?
    let homepage: String?
    let id: Int?
    let inProduction: Bool?
    let languages: [String]?
    let lastAirDate: String?
    let lastEpisodeToAir: LastEpisodeToAir?
    let name: String?
    let nextEpisodeToAir: NextEpisodeToAir?
    let networks: [Networks]?
    let numberOfEpisodes: Int?
    let numberOfSeasons: Int?
    let originCountry: [String]?
    let originalLanguage: String?
    let originalName: String?
    let overview: String?
    let popularity: Double?
    let posterPath: String?
    let productionCompanies: [ProductionCompanies]?
    let productionCountries: [ProductionCountries]?
    let seasons: [Seasons]?
    let spokenLanguages: [SpokenLanguages]?
    let status: String?
    let tagline: String?
    let type: String?
    let voteAverage: Double?
    let voteCount: Int?

}
struct CreatedBy: Codable {

    let id: Int?
    let creditId: String?
    let name: String?
    let gender: Int?
    let profilePath: String?

}
struct LastEpisodeToAir: Codable {

    let airDate: String?
    let episodeNumber: Int?
    let id: Int?
    let name: String?
    let overview: String?
    let productionCode: String?
    let runtime: Int?
    let seasonNumber: Int?
    let showId: Int?
    let stillPath: String?
    let voteAverage: Double?
    let voteCount: Int?

}
struct Networks: Codable {

    let id: Int?
    let name: String?
    let logoPath: String?
    let originCountry: String?

}
struct ProductionCompanies: Codable {

    let id: Int?
    let logoPath: String?
    let name: String?
    let originCountry: String?

}

struct ProductionCountries: Codable {

    let iso31661: String?
    let name: String?

}
struct Seasons: Codable {

    let airDate: String?
    let episodeCount: Int?
    let id: Int?
    let name: String?
    let overview: String?
    let posterPath: String?
    let seasonNumber: Int?

}
struct SpokenLanguages: Codable {

    let englishName: String?
    let iso6391: String?
    let name: String?

}
struct NextEpisodeToAir: Codable {

    let airDate: String?
    let episodeNumber: Int?
    let id: Int?
    let name: String?
    let overview: String?
    let productionCode: String?
    let runtime: Int?
    let seasonNumber: Int?
    let showId: Int?
    let stillPath: String?
    let voteAverage: Int?
    let voteCount: Int?

}
