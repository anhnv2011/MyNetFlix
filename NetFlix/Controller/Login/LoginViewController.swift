//
//  LoginViewController.swift
//  NetFlix
//
//  Created by MAC on 7/25/22.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextfiled: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func login(username: String, password: String, requestToken: String){
        
        
    }
    func setupUI(){
        usernameTextfiled.layer.cornerRadius  = 12
        passwordTextfield.layer.cornerRadius = 12
        loginButton.layer.cornerRadius = 12
    }
    
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
