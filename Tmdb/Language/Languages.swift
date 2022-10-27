//
//  Languages.swift
//  NetFlix
//
//  Created by MAC on 10/10/22.
//


import UIKit

class Languages: NSObject {
    
    /// Language code to show in application to choese
    static var languages: [Language] = {
        
        var languages: [Language] = []
        languages.append(Language(languageCode: "en", language: "English"))
        languages.append(Language(languageCode: "vi", language: "Vietnam"))        
        
        return languages
    }()

   
    class func isLanguageAvailable(_ code: String) -> Bool {
        for language in languages {
            if  code == language.languageCode {
                return true
            }
        }
        return false
    }

//
    
    
    
    
    
    
    
    
    
    
    
    
//
//    // Find a Language based on it's Language code
//    //
//    // - Parameter code: Language code, exe. en
//    // - Returns: Language
//    class func languageFromLanguageCode(_ code: String) -> Language {
//        for language in languages {
//            if  code == language.languageCode {
//                return language
//            }
//        }
//        return Language.emptyLanguage
//    }
//    // Find a Language based on it's Language Name
//    //
//    // - Parameter languageName: languageName, exe. english
//    // - Returns: Language
//    class func languageFromLanguageName(_ languageName: String) -> Language {
//        for language in languages {
//            if languageName == language.language {
//                return language
//            }
//        }
//        return Language.emptyLanguage
//    }
//
}
