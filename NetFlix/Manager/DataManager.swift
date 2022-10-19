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
    
    func saveSessionId (id: String) {
//        UserDefaults.standard.setValue(id, forKey: "\(SessionId)")
//        UserDefaults.standard.synchronize()
        KeychainWrapper.standard.set(id, forKey: "SessionId")

    }
    func getSaveSessionId() -> String {
        let retrievedString: String = KeychainWrapper.standard.string(forKey: "SessionId") ?? ""
        return retrievedString
    }
    
    func removeSessionId(){
        
    }
    
    func saveProfileId (id: String) {
        UserDefaults.standard.setValue(id, forKey: "ProfileId")
        UserDefaults.standard.synchronize()
    }
    func getProfileId() -> String {
        let string = UserDefaults.standard.string(forKey: "ProfileId") ?? ""
        return string
    }
    func saveLanguage (code: String) {
        UserDefaults.standard.setValue(code, forKey: "CustomLanguage")
        UserDefaults.standard.synchronize()
    }
    func getLanguage() -> String {
        let string = UserDefaults.standard.string(forKey: "CustomLanguage") ?? "en"
        return string
    }
    func saveViewMode (mode: String) {
        
        UserDefaults.standard.setValue(mode, forKey: "ViewMode")
        UserDefaults.standard.synchronize()
    }
    func getViewMode() -> String {
        let string = UserDefaults.standard.string(forKey: "ViewMode") ?? ViewMode.darkMode.rawValue
        
        return string
    }
    
    var profileData:Profile?
   
    
}
