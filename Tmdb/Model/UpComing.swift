//
//  UpComming.swift
//  NetFlix
//
//  Created by MAC on 6/27/22.
//

import Foundation

struct UpComming: Codable {
    let dates: MinmaxDate
    let results: [Film]
}
struct MinmaxDate: Codable {
    let maximum: String
    let minimum: String
}
