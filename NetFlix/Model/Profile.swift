//
//  Profile.swift
//  NetFlix
//
//  Created by MAC on 9/27/22.
//

import Foundation
import SwiftyJSON

struct Profile {

    var avatar: Avatar?
    var id: Int?
    var iso6391: String?
    var iso31661: String?
    var name: String?
    var includeAdult: Bool?
    var username: String?

    init(_ json: JSON) {
        avatar = Avatar(json["avatar"])
        id = json["id"].intValue
        iso6391 = json["iso_639_1"].stringValue
        iso31661 = json["iso_3166_1"].stringValue
        name = json["name"].stringValue
        includeAdult = json["include_adult"].boolValue
        username = json["username"].stringValue
    }

}
struct Avatar {

    var gravatar: Gravatar?
    var tmdb: Tmdb?

    init(_ json: JSON) {
        gravatar = Gravatar(json["gravatar"])
        tmdb = Tmdb(json["tmdb"])
    }

}
struct Gravatar {

    var hash: String?

    init(_ json: JSON) {
        hash = json["hash"].stringValue
    }

}

struct Tmdb {

    var avatarPath: String?

    init(_ json: JSON) {
        avatarPath = json["avatar_path"].stringValue
    }

}
