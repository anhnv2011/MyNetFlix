//
//  UIColor-Extension.swift
//  NetFlix
//
//  Created by MAC on 10/6/22.
//

import Foundation
import UIKit
extension UIColor {
    class func buttonBackground() -> UIColor {
        return UIColor(red: 42/255, green: 42/255, blue: 42/255, alpha: 1.00)
    }
    class func viewBackground() -> UIColor {
        return UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1)
    }
    class func popupBackground() -> UIColor {
        return UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 0.5)
    }
    class func cellBackground() -> UIColor {
        return UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
    }
    class func backgroundColor() -> UIColor {
        return UIColor.black
    }
    class func tabbarBackground() -> UIColor {
        return UIColor(red: 12/255, green: 12/255, blue: 12/255, alpha: 1.00)
    }
    class func naviBackground() -> UIColor {
        return UIColor(red: 12/255, green: 12/255, blue: 12/255, alpha: 1.00)
    }
    class func sectionBackground() -> UIColor {
        return UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.00)
    }
   
    class func borderColor() -> UIColor {
        return UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha: 1.00)
    }
    
    class func labelColor() -> UIColor {
        return UIColor.white
    }
}
