//
//  LoginViewController.swift
//  NetFlix
//
//  Created by MAC on 7/25/22.
//

import UIKit
import RxSwift
import RxCocoa
import SafariServices

class LoginViewController: UIViewController {
    
  
    @IBOutlet weak var passwordLeadingConstrains: NSLayoutConstraint!
    @IBOutlet weak var emailLeadingConstrains: NSLayoutConstraint!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var usernameTextfiled: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var showPasswordButton: UIButton!
    private let loginViewModel = LoginViewModel()
    let disposeBag = DisposeBag()
   
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindData()
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: Notification.Name("ChangeLanguage"), object: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        emailLeadingConstrains.constant = 400
        passwordLeadingConstrains.constant = -400
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIView.animate(withDuration: 1) { [weak self] in
            guard let strongSelf = self else { return }
            
            strongSelf.emailLeadingConstrains.constant = 12
            strongSelf.passwordLeadingConstrains.constant = 12
            strongSelf.view.layoutIfNeeded()
        }
    }
    
    
    @objc func changeLanguage(){
        setupUI()
    }
    //MARK:- Action
    @IBAction func buttonAction(_ sender: UIButton) {
        
        switch sender {
        case loginButton:
            login()
        case signUpButton:
            signup()
        case showPasswordButton:
            showPassword()
        default:
            print("")
        }
        
    }
    
    private func animateLogin(text: String){
        loginLabel.text = ""
        var charIndex = 0
        for character in text {
            charIndex += 1
            Timer.scheduledTimer(withTimeInterval: 0.3 * Double(charIndex), repeats: false) { [weak self](_) in
                guard let strongSelf = self else { return }
                strongSelf.loginLabel.text?.append(character)
            }
        }
       
    }
    
    private func setupUI(){
        loginLabel.text = ""
//        let loginLabel =  RKLocalizedString(key: "Login_Label", comment: "")
//        let customLang = CustomLanguage() //declare at top
//        let bundleLanguage = customLang.createBundlePath()

//        let loginLabel = NSLocalizedString("Login_Label", tableName: nil, bundle: bundleLanguage, value: "", comment: "")
//        let loginLabel = NSLocalizedString("Login_Label", comment: "")
        
        let loginLabel = "Login_Label".localized()
        animateLogin(text: loginLabel)
        usernameTextfiled.layer.cornerRadius  = 5
        
        passwordTextfield.layer.cornerRadius = 5
        passwordTextfield.isSecureTextEntry = true
        passwordTextfield.delegate = self
        
        loginButton.layer.cornerRadius = 12
        
        showPasswordButton.isHidden = true
    
        userView.layer.borderWidth = 1
        userView.layer.borderColor = UIColor.borderColor().cgColor
        userView.layer.cornerRadius = 12
        
        passwordView.layer.borderWidth = 1
        passwordView.layer.borderColor = UIColor.borderColor().cgColor
        passwordView.layer.cornerRadius = 12
    }
    

    @IBAction func testlanguage(_ sender: UIButton) {
//        RKLocalization.shared.setLanguage(language: "en")
//
////        let loginLabel =  RKLocalizedString(key: "Login_Label", comment: "")
////        print(loginLabel)
////        animateLogin(text: loginLabel)
//        setupUI()
////        let vc = ProfileViewController()
////        vc.delegate = self
////        navigationController?.pushViewController(vc, animated: true)
        
        let vc = ProfileViewController()
        navigationController?.pushViewController(vc, animated: true)
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
    
   
    private func login(){
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
    func signup(){
        guard let url = URL(string: "https://www.themoviedb.org/signup") else {return}
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true, completion: nil)
    }
    func showPassword(){
        passwordTextfield.isSecureTextEntry.toggle()
        passwordTextfield.isSecureTextEntry ? showPasswordButton.setImage(UIImage(systemName: "eye"), for: .normal   ) : showPasswordButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
    }
//    @IBAction func actionLogin(_ sender: Any) {
//        guard let username = self.usernameTextfiled.text, !username.isEmpty,
//              let password = self.passwordTextfield.text, !password.isEmpty else {
//            print("nhap user, pass")
//            return
//        }
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


extension LoginViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        showPasswordButton.isHidden = textField.text == nil
    }
}



extension LoginViewController : LanguageSelectionDelegate{
    
    func settingsViewController(_ settingsViewController: ProfileViewController, didSelectLanguage language: Language) {

        print("LoginViewController")
//  Set selected language to application language
//        RKLocalization.shared.setLanguage(language: language.languageCode)
        
////  Reload application bundle as new selected language
//        DispatchQueue.main.async(execute: {
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            appDelegate.initRootView()
//        })
    }
}

//struct CustomLanguage {
//
//    func createBundlePath () -> Bundle {
//        let selectedLanguage = "v"
//        let path = Bundle.main.path(forResource: selectedLanguage, ofType: "lproj")
//        return Bundle(path: path!)!
//    }
//}
