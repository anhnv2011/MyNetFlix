//
//  ActionAlert.swift
//  Tmdb
//
//  Created by MAC on 10/14/22.
//

import Foundation
import UIKit

class ActionAlert {
    var title: String
    var style: ActionAlertStyle
    var actionHandler: () -> Void

    init(with title: String, style: ActionAlertStyle = .normal, actionHandler: @escaping () -> Void) {
        self.title = title
        self.style = style
        self.actionHandler = actionHandler
    }
}
enum ActionAlertStyle {
    case normal
    case destructive
  
    
    var titleColor: UIColor {
        switch self {
        case .destructive:
            return UIColor.white
        case .normal:
            return UIColor.labelColor()
        }
    }
    var backgroundColor: UIColor {
        switch self {
        case .normal:
            return UIColor.darkGray.withAlphaComponent(0.5)
        case .destructive:
            return UIColor.red
    
        }
    }
    
    var highlightedTitleColor: UIColor {
        switch self {
        case .normal, .destructive:
            return self.titleColor.withAlphaComponent(0.6)
        }
    }
}
