//
//  String-Extension.swift
//  NetFlix
//
//  Created by MAC on 9/25/22.
//

import Foundation
extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
extension String {
func localized() ->String {
    let lang = DataManager.shared.getLanguage()
    let path = Bundle.main.path(forResource: lang, ofType: "lproj")
    let bundle = Bundle(path: path!)

    return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
}}
