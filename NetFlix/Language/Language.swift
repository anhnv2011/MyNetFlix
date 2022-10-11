//
//  Language.swift
//  NetFlix
//
//  Created by MAC on 10/10/22.
//

import UIKit

class Language: NSObject {
    
    open var languageCode : String
    open var language : String
    
    public static var emptyLanguage:Language{
        return Language(languageCode: "", language: "")
        
    }
    
    
    
//     Constructor to initialize a country
//
//     - Parameters:
//     - countryCode: the country code
    public init(languageCode: String, language: String) {
        
        self.languageCode = languageCode
        self.language = language
        
    }
    
    open override var description: String{
        return self.languageCode + " " + self.language
    }
}
