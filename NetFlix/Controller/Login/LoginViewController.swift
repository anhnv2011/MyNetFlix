//
//  LoginViewController.swift
//  NetFlix
//
//  Created by MAC on 7/25/22.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextfiled: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    private let loginViewModel = LoginViewModel()
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindData()
    }
    
    func login(username: String, password: String, requestToken: String){
        
        
    }
    func setupUI(){
        usernameTextfiled.layer.cornerRadius  = 12
        passwordTextfield.layer.cornerRadius = 12
        loginButton.layer.cornerRadius = 12
    }
    
    func bindData(){
        usernameTextfiled.becomeFirstResponder()
        usernameTextfiled.rx.text.map({$0 ?? ""})
            .bind(to: loginViewModel.usernameTextFieldSubject)
            .disposed(by: disposeBag)
        passwordTextfield.rx.text.map({$0 ?? ""})
            .bind(to: loginViewModel.passwordTextFieldSubject)
            .disposed(by: disposeBag)
        loginViewModel.isValid()
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
//        loginButton.rx.tap
//            .asDriver()
//            .drive { [weak self] _ in
//                self?.login()
//            }
//            .disposed(by: disposeBag)
       
            
    }
//    func login(){
//        let username = self.usernameTextfiled.text
//        let password = self.passwordTextfield.text
////        loginViewModel.login(username: username!, password: password!){_ in
////
////        }
//
//    }
    
    @IBAction func actionLogin(_ sender: Any) {
        guard let username = self.usernameTextfiled.text, !username.isEmpty,
              let password = self.passwordTextfield.text, !password.isEmpty else {
            print("nhap user, pass")
            return
        }
        APICaller.share.getRequestToken { (result) in
            switch result {
            
            case .success(let auth):
                let requestToken = auth.request_token
             
                
                APICaller.share.creatSessionWithLogin(username: username, password: password, requestToken: requestToken) { result in
                    switch result{
                    case .success(let loginresult):
                        
                        let success = loginresult
                            .success
                        if success == true {
                            print("ssssssssssssssssssssss")
                            APICaller.share.getSessionId(requesToken: requestToken) { (result) in
                                switch result{
                                case .success(let sessionID):
                                    print("aaa")
                                    DispatchQueue.main.async {
                                        DataManager.shared.saveSessionId(id: sessionID)
                                        let vc = MainTabBarViewController()
                                        vc.modalPresentationStyle = .fullScreen
                                        self.present(vc, animated: true, completion: nil)
                                    }
                                   
                                case .failure(let error):
                                    print(error.localizedDescription)
                                
                                }
                            }
                            
                        } else {
                            print(loginresult.status_message ?? "fail")
                            
                            DispatchQueue.main.async {
                                let aleart = UIAlertController(title: "Error", message: loginresult.status_message ?? "fail", preferredStyle: .alert)
                                aleart.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                                self.present(aleart, animated: true, completion: nil)
                            }
                            
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
