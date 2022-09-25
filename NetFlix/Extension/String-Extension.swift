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
