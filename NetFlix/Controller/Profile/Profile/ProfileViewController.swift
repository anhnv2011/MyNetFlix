//
//  ProfileViewController.swift
//  NetFlix
//
//  Created by MAC on 9/15/22.
//

import UIKit
import SDWebImage
//enum ProfilePage:String, CaseIterable {
//    case favorite = "Favorite"
//    case recommendation = "Recommendation"
//    case list = "Your list"
//    case rating = "Ratings"
//    case watchList = "Watch list"
//}
protocol LanguageSelectionDelegate {
    
   
    // Comunicate delegates that a country has been selected
    //
    //   - Parameters:
    //   - settingsViewController: settingsViewController
    //   - language: selected language
    func settingsViewController(_ settingsViewController: ProfileViewController, didSelectLanguage language: Language)
   
}


class ProfileSetting{
    let title: String
    let option : [String]
    let image: String
    var isOpen: Bool
    init(title: String, option: [String], image: String, isopen:Bool) {
        self.title = title
        self.option = option
        self.image = image
        self.isOpen = isopen
    }
}

class ProfileViewController: UIViewController {
    
   
    @IBOutlet weak var accountView: UIView!
    @IBOutlet weak var avartarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    
    let languages = Languages.languages
    var delegate : LanguageSelectionDelegate?


//    var transitionDelegate: UIViewControllerTransitioningDelegate!
    var transitionDelegate = TransitionDelegate()
    let simpleOver = SimpleOver()
    var profileSetting = [ProfileSetting]()
    var profileData: Profile?
    {
        didSet {
            DispatchQueue.main.async {
                self.setupUI()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData()
//        self.transitioningDelegate = self

        self.transitioningDelegate = transitioningDelegate

    }

    
    //MARK:- button Action
    @IBAction func buttonAction(_ sender: UIButton) {
        switch sender {
        case dismissButton:
            dismiss(animated: true, completion: nil)
        case logOutButton:
            logOutControl()
            
        default:
            break
        }
    
    }
    
  
    
    //MARK:- Fetch Data
    private func fetchData(){
        settingProfile()

        self.profileData = DataManager.shared.profileData
        
    }
    private func settingProfile(){
        profileSetting = [
            ProfileSetting(title: "Favarite", option: ["Movie", "Tv"], image: ImageName.shared.favoriteButton, isopen: false),
            ProfileSetting(title: "Book mark", option: ["Movie", "Tv"], image: ImageName.shared.bookmarkButton, isopen: false),
            ProfileSetting(title: "Your list", option: ["List"], image: ImageName.shared.listButton, isopen: false),
            ProfileSetting(title: "Ratings", option: ["Movie", "Tv"], image: ImageName.shared.rateButton, isopen: false),
            ProfileSetting(title: "Language", option: languages.map({$0.language}), image: ImageName.shared.language, isopen: false)
        ]
    }
    
    private func logOutControl(){
        let logOutAleart = UIAlertController(title: "Log out", message: "Are you sure", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self](_) in
            guard let strongSelf = self else {return}
            strongSelf.logOutAction()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (_) in
            
        }
        logOutAleart.addAction(okAction)
        logOutAleart.addAction(cancelAction)
        present(logOutAleart, animated: true, completion: nil)
    }
    
    private func logOutAction(){
        print("")
    }
    //MARK:- UI
    private func setupUI(){
        setupTableView()

//        view.backgroundColor = UIColor.popupBackground()
        accountView.backgroundColor = UIColor.sectionBackground()
        logOutButton.backgroundColor = UIColor.buttonBackground()
        
        avartarImageView.layer.cornerRadius = avartarImageView.frame.size.height / 2 
        
        let url = URL(string: "\(Constanst.ImageBaseUrl)\(profileData?.avatar?.tmdb?.avatarPath ?? "")")
        
        avartarImageView.sd_setImage(with: url, completed: nil)
        usernameLabel.text = profileData?.username ?? ""
        nameLabel.text = profileData?.name ?? ""
        
        
        
    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(UINib(nibName: "ExpenableHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: ExpenableHeaderView.identifier)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.sectionBackground()

    }

    
    //MARK:- TableViewAction
    private func selectedLanguages(selectedLanguage: String){
        DataManager.shared.saveLanguage(code: selectedLanguage)
        NotificationCenter.default.post(name: Notification.Name("ChangeLanguage"), object: nil)
    }
    private func showYourList(){
        let vc = WatchListViewController()
        vc.transitioningDelegate = transitionDelegate
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK:- Tableview Extension
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate, ExpenableHeaderViewDelegate {
    func toggleSection(header: ExpenableHeaderView, section: Int) {
        profileSetting[section].isOpen = !profileSetting[section].isOpen
        tableView.beginUpdates()
        for i in 0..<profileSetting[section].option.count {
            tableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
            
        }
        tableView.endUpdates()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        profileSetting.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let section = profileSetting[section]
        return section.option.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        44
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if profileSetting[indexPath.section].isOpen {
            return 44
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ExpenableHeaderView.identifier) as! ExpenableHeaderView
        header.customInit(title: profileSetting[section].title, image: profileSetting[section].image, section: section, delegate: self)
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor.viewBackground()
        cell.textLabel?.text = profileSetting[indexPath.section].option[indexPath.row]
        cell.textLabel?.textColor = .white
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//
//        let vc = LibraryViewController()
//        if indexPath.row == 0 {
//            vc.state = .movie
//            navigationController?.pushViewController(vc, animated: true)
//
//        } else {
//            vc.state = .tv
//            navigationController?.pushViewController(vc, animated: true)
//
//        }
        switch indexPath.section {
        
        //Favorite
        case 0:
        print("Favorite")
        
        //Bookmark
        case 1:
        print("")
        
        // Your List
        case 2:
            showYourList()
            
        //Rating
        case 3:
        print("")
        
        //Language
        case 4:
            let selectedLanguage = self.languages[indexPath.row].languageCode
//            print(selectedLanguage)
//            delegate?.settingsViewController(self, didSelectLanguage: selectedLanguage)
        
            selectedLanguages(selectedLanguage: selectedLanguage)
           
        default:
            break
        }
        
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
    }
    
}
extension ProfileViewController: UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {
    func navigationController(
           _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
           from fromVC: UIViewController,
           to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
           
           simpleOver.popStyle = (operation == .pop)
           return simpleOver
       }
}
