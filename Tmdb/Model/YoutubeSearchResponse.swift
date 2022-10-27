//
//  YoutubeSearchResponse.swift
//  NetFlix
//
//  Created by MAC on 10/5/22.
//

import Foundation
struct YoutubeSearchResponse: Codable {
    let items: [VideoElement]
}


struct VideoElement: Codable {
    let id: IdVideoElement
}


struct IdVideoElement: Codable {
    let kind: String
    let videoId: String
}
