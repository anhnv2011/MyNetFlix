//
//  DataManager.swift
//  NetFlix
//
//  Created by MAC on 9/14/22.
//

import Foundation
import UIKit
struct DataManager {
    static let shared = DataManager()
    
    //MARK:- User defaultValue
    //key
    var SessionId = ""
    
    func saveSessionId (id: String) {
        UserDefaults.standard.setValue(id, forKey: "SessionId")
        UserDefaults.standard.synchronize()
    }
    func getSaveSessionId() -> String {
        let string = UserDefaults.standard.string(forKey: "SessionId") ?? ""
        return string
    }
}
