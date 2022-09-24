//
//  LoginViewModel.swift
//  NetFlix
//
//  Created by MAC on 9/23/22.
//

import Foundation
import RxSwift
import UIKit
class LoginViewModel {
    let usernameTextFieldSubject = PublishSubject<String>()
    let passwordTextFieldSubject = PublishSubject<String>()
    
    func isValid() -> Observable<Bool>{
        return Observable.combineLatest(usernameTextFieldSubject.asObservable(), passwordTextFieldSubject.asObservable()).map({ username, password in
            
            return username.count > 0 && password.count > 0
        })
        .startWith(false)
    }
    
//    func login(username: String, password:String) {
//      
//        APICaller.share.getRequestToken { (result) in
//            switch result {
//            
//            case .success(let auth):
//                let requestToken = auth.request_token
//                
//                
//                APICaller.share.creatSessionWithLogin(username: username, password: password, requestToken: requestToken) { result in
//                    switch result{
//                    case .success(let loginresult):
//                        
//                        let success = loginresult
//                            .success
//                        if success == true {
//                            print("ssssssssssssssssssssss")
//                            APICaller.share.getSessionId(requesToken: requestToken) { (result) in
//                                switch result{
//                                case .success(let sessionID):
//                                    print("aaa")
//                                    DispatchQueue.main.async {
//                                        DataManager.shared.saveSessionId(id: sessionID)
//                                        let vc = MainTabBarViewController()
//                                        vc.modalPresentationStyle = .fullScreen
//                                        self.present(vc, animated: true, completion: nil)
//                                    }
//                                    
//                                case .failure(let error):
//                                    print(error.localizedDescription)
//                                    
//                                }
//                            }
//                            
//                        } else {
//                            print(loginresult.status_message ?? "fail")
//                            
//                            DispatchQueue.main.async {
//                                let aleart = UIAlertController(title: "Error", message: loginresult.status_message ?? "fail", preferredStyle: .alert)
//                                aleart.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//                                self.present(aleart, animated: true, completion: nil)
//                            }
//                            
//                        }
//                    case .failure(let error):
//                        print(error.localizedDescription)
//                    }
//                }
//                
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
}
