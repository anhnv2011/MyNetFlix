//
//  DataManager.swift
//  NetFlix
//
//  Created by MAC on 9/14/22.
//

import Foundation
import UIKit
import SwiftKeychainWrapper
struct DataManager {
    static var shared = DataManager()
    
    //MARK:- User defaultValue
    //key
    let SessionId = "SessionId"
    let ProfileId = "ProfileId"
    let CustomLanguage = "CustomLanguage"
    func saveSessionId (id: String) {
//        UserDefaults.standard.setValue(id, forKey: "\(SessionId)")
//        UserDefaults.standard.synchronize()
        KeychainWrapper.standard.set(id, forKey: "SessionId")

    }
    func getSaveSessionId() -> String {
        let retrievedString: String = KeychainWrapper.standard.string(forKey: "SessionId") ?? ""

        return retrievedString
    }
    
    func saveProfileId (id: String) {
        UserDefaults.standard.setValue(id, forKey: "\(ProfileId)")
        UserDefaults.standard.synchronize()
    }
    func getProfileId() -> String {
        let string = UserDefaults.standard.string(forKey: "\(ProfileId)") ?? ""
        return string
    }
    func saveLanguage (code: String) {
        UserDefaults.standard.setValue(code, forKey: "\(CustomLanguage)")
        UserDefaults.standard.synchronize()
    }
    func getLanguage() -> String {
        let string = UserDefaults.standard.string(forKey: "\(CustomLanguage)") ?? "en"
        return string
    }
    
    
    var profileData:Profile?
    var favoriteMovie:[Film]?
    var favoriteTv:[Film]?
    var watchListMovie:[Film]?
    var watchListTv:[Film]?
    
}
