//
//  UiviewController-Extension.swift
//  NetFlix
//
//  Created by MAC on 9/28/22.
//

import Foundation
import UIKit
extension UIViewController {
    //    func makeAlert(title: String, messaage: String){
    //
    //        DispatchQueue.main.async {
    //            let aleart = UIAlertController(title: title, message: messaage, preferredStyle: .alert)
    //            aleart.addAction(.init(title: "Ok", style: .cancel, handler: nil))
    //            self.present(aleart, animated: true, completion: nil)
    //        }
    //
    //    }
    
    func makeBasicCustomAlert(title: String, messaage: String){
        DispatchQueue.main.async {
            let cancelAction = ActionAlert(with: "Cancel".localized(), style: .normal) {[weak self] in
                guard let strongSelf = self else {return}
                strongSelf.dismiss(animated: true, completion: nil)
            }
            
            let alertVC = CustomAlertViewController(withTitle: title, message: messaage, actions: [cancelAction], axis: .horizontal, style: .dark)
            
            alertVC.modalPresentationStyle = .overCurrentContext
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true, completion: nil)
        }
    }
}
