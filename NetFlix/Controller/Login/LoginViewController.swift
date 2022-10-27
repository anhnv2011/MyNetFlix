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
    
    //MARK:- Outlet
    @IBOutlet weak var passwordLeadingConstrains: NSLayoutConstraint!
    @IBOutlet weak var emailLeadingConstrains: NSLayoutConstraint!
    @IBOutlet weak var loginLeftConstrains: NSLayoutConstraint!
    @IBOutlet weak var loginRightConstrains: NSLayoutConstraint!
    
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var userView: UIView!
    
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var dontHaveAccLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    @IBOutlet weak var usernameTextfiled: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var showPasswordButton: UIButton!
    private let loginViewModel = LoginViewModel()
    let disposeBag = DisposeBag()
    
    var transitionDelegate = TransitionDelegate()
   
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindData()
        notificationCenter()
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
    
    private func notificationCenter(){
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: Notification.Name("ChangeLanguage"), object: nil)
    }
    @objc func changeLanguage(){
        setupUI()
    }
    
    //MARK:- UI
    private func setupUI(){
       
        setupLabel()
        setupButton()
        setupView()
        setupTextfield()
    }
    
    private func setupLabel(){
        loginLabel.text = ""
        loginLabel.textColor = UIColor.labelColor()
        let loginLabel = "Login_Label".localized()
        animateLoginLabel(text: loginLabel)
        
        usernameLabel.text = "Username".localized()
        usernameLabel.textColor = UIColor.labelColor()
        
        passwordLabel.text = "Password".localized()
        passwordLabel.textColor = UIColor.labelColor()
        
        dontHaveAccLabel.text = "Don't have an account ?".localized()
        dontHaveAccLabel.textColor = UIColor.labelColor()
        
        errorLabel.isHidden = true
    }
    
    private func setupButton(){
        loginButton.layer.cornerRadius = 12
        loginButton.setTitle("Login_Button".localized(), for: .normal)
        signUpButton.setTitle("Sign Up".localized(), for: .normal)
        showPasswordButton.isHidden = true
    }
    
    private func setupView(){
        view.backgroundColor = UIColor.backgroundColor()
        userView.layer.borderWidth = 1
        userView.layer.borderColor = UIColor.borderColor().cgColor
        userView.backgroundColor = UIColor.viewBackground()
        userView.layer.cornerRadius = 12
        
        passwordView.layer.borderWidth = 1
        passwordView.layer.borderColor = UIColor.borderColor().cgColor
        passwordView.backgroundColor = UIColor.viewBackground()
        passwordView.layer.cornerRadius = 12
    }
    
    private func setupTextfield(){
        usernameTextfiled.layer.cornerRadius = 5
        passwordTextfield.layer.cornerRadius = 5
        passwordTextfield.isSecureTextEntry = true
        passwordTextfield.delegate = self
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
    //MARK:- Button Action
    @IBAction func buttonAction(_ sender: UIButton) {
        
        switch sender {
        case loginButton:
//            loginAnimation(sender: sender)
            login(sender: sender)
        case signUpButton:
            signup()
        case showPasswordButton:
            showPassword()
        default:
            print("")
        }
        
    }
    
    private func animateLoginLabel(text: String){
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
    
   
    private func loginAnimation(sender: UIButton){
        
        let height = sender.frame.size.height
        let value = (view.frame.width - height)/2
        sender.setTitle("", for: .normal)
        sender.clipsToBounds = true
        CircleButton.customAnimation(sender: sender, leftConstrain: loginLeftConstrains, rightConstrain: loginRightConstrains, height: value, vc: self) {
            
            let vc = MainTabBarViewController()
            vc.modalPresentationStyle = .fullScreen
            vc.transitioningDelegate = self.transitionDelegate
            self.present(vc, animated: true, completion: nil)
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

}

    //MARK:- TextFielf Delegate
extension LoginViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        showPasswordButton.isHidden = textField.text == nil
    }
}


    //MARK:- login func
extension LoginViewController {
    private func login(sender: UIButton){
        guard let username = self.usernameTextfiled.text, !username.isEmpty,
              let password = self.passwordTextfield.text, !password.isEmpty else {
            print("nhap user, pass")
            return
        }
        APICaller.share.getRequestToken { [weak self] (result) in
            guard let strongSelf = self else {return}

            switch result {
            
            case .success(let auth):
                let requestToken = auth.request_token
                strongSelf.creatSessionLogin(username: username, password: password, requestToken: requestToken, sender: sender)
                
                
            case .failure(let error):
                strongSelf.makeBasicCustomAlert(title: "Error", messaage: error.localizedDescription)
            }
        }
    }
    
    private func creatSessionLogin(username: String, password:String, requestToken: String, sender: UIButton){
        APICaller.share.creatSessionWithLogin(username: username, password: password, requestToken: requestToken) { [weak self]result in
            guard let strongSelf = self else {return}
            switch result{
            case .success(let loginresult):
                
                let success = loginresult
                    .success
                if success == true {
                    print("ssssssssssssssssssssss")
                    strongSelf.getSesionID(requestToken: requestToken, sender: sender)
                    
                } else {
                    
//                    strongSelf.makeBasicCustomAlert(title: "Error", messaage: loginresult.status_message ?? "fail")
                    
                    
                    DispatchQueue.main.async {
                        strongSelf.errorLabel.text = loginresult.status_message ?? "fail"
                        strongSelf.errorLabel.isHidden = false

                        ShakeButton.shake(sender: sender)
//                        let aleart = UIAlertController(title: "Error", message: loginresult.status_message ?? "fail", preferredStyle: .alert)
//                        aleart.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//                        strongSelf.present(aleart, animated: true, completion: nil)
                    }
                    
                }
            case .failure(let error):
                strongSelf.makeBasicCustomAlert(title: "Error", messaage: error.localizedDescription)
            }
        }
    }
    
    
    private func getSesionID(requestToken: String, sender: UIButton){
        APICaller.share.getSessionId(requesToken: requestToken) { [weak self] result in
            guard let strongSelf = self else {return}
            switch result{
            case .success(let sessionID):
                print("aaa")
                DispatchQueue.main.async {
                    DataManager.shared.saveSessionId(id: sessionID)
                    strongSelf.loginAnimation(sender: sender)

                }
               
            case .failure(let error):
                print(error.localizedDescription)
            
            }
        }
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
