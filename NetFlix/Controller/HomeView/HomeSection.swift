//
//  HomeSection.swift
//  NetFlix
//
//  Created by MAC on 9/13/22.
//

import Foundation

enum HomeSection: CaseIterable {
    case TrendingAll
    case TrendingMovie
    case TrendingTv
    case Popular
    case TopRate
    var title: String {
        switch self {
        case .TrendingAll:
            return "Trending ALL"
        case .TrendingMovie:
            return "Trending Movie"
        case .TrendingTv:
            return "Trending Tv"
        case .Popular:
            return "Popular"
        case .TopRate:
            return "Top Rate"
        }
    }
    
}
