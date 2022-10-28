//
//  UIColor-Extension.swift
//  Tmdb
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
        if DataManager.shared.getViewMode() == ViewMode.allCases[0].rawValue{ //dark mode
            return UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1)
        } else if  DataManager.shared.getViewMode() == ViewMode.allCases[1].rawValue { // light mode
            return UIColor.white
        } else {
            return UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1)
            
        }
//        return UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1)
    }
    
    class func toggleButtonColor() -> UIColor {
        return UIColor(red: 78/255, green: 177/255, blue: 204/255, alpha: 1.00)
    }
    class func popupBackground() -> UIColor {
        return UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 0.5)
    }
    class func cellBackground() -> UIColor {
        //        return UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        if DataManager.shared.getViewMode() == ViewMode.allCases[0].rawValue{ //dark mode
            return UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        } else if  DataManager.shared.getViewMode() == ViewMode.allCases[1].rawValue { // light mode
            return UIColor.white
        } else {
            return UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
            
        }
    }
    class func backgroundColor() -> UIColor {
        if DataManager.shared.getViewMode() == ViewMode.allCases[0].rawValue{ //dark mode
            return UIColor.black
        } else if  DataManager.shared.getViewMode() == ViewMode.allCases[1].rawValue {
            return UIColor.white
            
        } else {
            return UIColor.black
            
        }
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
        
        if DataManager.shared.getViewMode() == ViewMode.allCases[0].rawValue{ //dark mode
            return UIColor.white
        } else if  DataManager.shared.getViewMode() == ViewMode.allCases[1].rawValue {
            return UIColor.black
        } else {
            return UIColor.white
            
        }
        
    }
}
