//
//  DataManager.swift
//  NetFlix
//
//  Created by MAC on 9/14/22.
//

import Foundation
import UIKit
struct DataManager {
    static var shared = DataManager()
    
    //MARK:- User defaultValue
    //key
    let SessionId = "SessionId"
    let ProfileId = "ProfileId"
    func saveSessionId (id: String) {
        UserDefaults.standard.setValue(id, forKey: "\(SessionId)")
        UserDefaults.standard.synchronize()
    }
    func getSaveSessionId() -> String {
        let string = UserDefaults.standard.string(forKey: "\(SessionId)") ?? ""
        return string
    }
    
    func saveProfileId (id: String) {
        UserDefaults.standard.setValue(id, forKey: "\(ProfileId)")
        UserDefaults.standard.synchronize()
    }
    func getProfileId() -> String {
        let string = UserDefaults.standard.string(forKey: "\(ProfileId)") ?? ""
        return string
    }
    
    
    var profileData:Profile?
    var favoriteMovie:[Film]?
    var favoriteTv:[Film]?
    var watchListMovie:[Film]?
    var watchListTv:[Film]?
    
}
