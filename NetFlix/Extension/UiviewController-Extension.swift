//
//  UiviewController-Extension.swift
//  NetFlix
//
//  Created by MAC on 9/28/22.
//

import Foundation
import UIKit
extension UIViewController {
    func makeAlert(title: String, messaage: String){
        
        DispatchQueue.main.async {
            let aleart = UIAlertController(title: title, message: messaage, preferredStyle: .alert)
            aleart.addAction(.init(title: "Ok", style: .cancel, handler: nil))
            self.present(aleart, animated: true, completion: nil)
        }
       
    }
    
}
