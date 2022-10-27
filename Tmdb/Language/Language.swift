//
//  Language.swift
//  Tmdb
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
    

    public init(languageCode: String, language: String) {
        
        self.languageCode = languageCode
        self.language = language
        
    }
    
    open override var description: String{
        return self.languageCode + " " + self.language
    }
}
