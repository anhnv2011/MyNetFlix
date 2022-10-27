//
//  ProfileViewController.swift
//  NetFlix
//
//  Created by MAC on 9/15/22.
//

import UIKit

protocol LanguageSelectionDelegate {
    
    func settingsViewController(_ settingsViewController: ProfileViewController, didSelectLanguage language: Language)
    
}

enum ViewMode: String, CaseIterable {
    case darkMode = "Dark Mode"
    case lightMode = "Light Mode"
    
}

//MARK:- Model
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
    
    //MARK:- Outlet
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var accountView: UIView!
    @IBOutlet weak var avartarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dismissButton: UIButton!
    
    let languages = Languages.languages
    var delegate : LanguageSelectionDelegate?
    
    
    //    var transitionDelegate: UIViewControllerTransitioningDelegate!
    var transitionDelegate = TransitionDelegate()
    //    let simpleOver = SimpleOver()
    var profileSetting = [ProfileSetting]()
    var profileData: Profile?
    {
        didSet {
            DispatchQueue.main.async {
                self.setupUI()
            }
        }
    }
    
    //MARK:- Life Cycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        navigationController?.navigationBar.prefersLargeTitles = false
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData()
        //        self.transitioningDelegate = self
        
        self.transitioningDelegate = transitioningDelegate
        
        
    }
    
    //MARK:- Fetch Data
    private func fetchData(){
        
        self.profileData = DataManager.shared.profileData
    }
    private func settingProfile(){
        profileSetting = [
            ProfileSetting(title: "Favorite".localized(), option: ["Movie".localized(), "Tv".localized()], image: ImageName.shared.favoriteButton, isopen: false),
            ProfileSetting(title: "WatchList".localized(), option: ["Movie".localized(), "Tv".localized()], image: ImageName.shared.bookmarkButton, isopen: false),
            ProfileSetting(title: "List".localized(), option: ["List".localized()], image: ImageName.shared.listButton, isopen: false),
            ProfileSetting(title: "Rate".localized(), option: ["Movie".localized(), "Tv".localized()], image: ImageName.shared.rateButton, isopen: false),
            ProfileSetting(title: "Language".localized(), option: languages.map({$0.language}), image: ImageName.shared.language, isopen: false),
            ProfileSetting(title: "Display".localized(), option: ViewMode.allCases.map({$0.rawValue.localized()}), image: ImageName.shared.rateButton, isopen: false),
            ProfileSetting(title: "", option: [""], image: "", isopen: true),
        ]
    }
    
    //MARK:- Button Action
    @IBAction func buttonAction(_ sender: UIButton) {
        switch sender {
        case dismissButton:
            navigationController?.popViewController(animated: true)
        default:
            break
        }
        
    }
    
    
    
    private func logOutControl(){
        
        let cancelAction = ActionAlert(with: "Cancel".localized(), style: .normal) {[weak self] in
            guard let strongSelf = self else {return}
            strongSelf.dismiss(animated: true, completion: nil)
        }
        let deleteAction = ActionAlert(with: "Log Out".localized(), style: .destructive) {[weak self] in
            guard let strongSelf = self else {return}
            strongSelf.logOutAction()
        }
        let alertVC = CustomAlertViewController(withTitle: "Are you sure?".localized(), message: "You will log out".localized(), actions: [cancelAction, deleteAction], axis: .horizontal, style: .dark)
        
        alertVC.modalPresentationStyle = .overCurrentContext
        alertVC.modalTransitionStyle = .crossDissolve
        present(alertVC, animated: true, completion: nil)
        
    }
    
    private func logOutAction(){
        DataManager.shared.removeSessionId()
        let transition = TransitionDelegate()
        self.transitionDelegate = transition
        let vc = LoginViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
        
    }
    //MARK:- UI
    private func setupUI(){
        setupTableView()
        settingProfile()
        setupLabel()
        setupImage()
        setupSubView()
        tableView.reloadData()
        
    }
    
    private func setupSubView(){
        accountView.backgroundColor = UIColor.viewBackground()
        
    }
    private func setupImage(){
        
        avartarImageView.layer.cornerRadius = avartarImageView.frame.size.height / 2
        let url =  "\(Constanst.ImageBaseUrl)\(profileData?.avatar?.tmdb?.avatarPath ?? "")"
        
        avartarImageView.loadImageUsingCache(url)
    }
    
    private func setupLabel(){
        accountLabel.text = "Account".localized()
        accountLabel.textColor = UIColor.labelColor()
        
        usernameLabel.text = profileData?.username ?? ""
        usernameLabel.textColor = UIColor.labelColor()
        
        nameLabel.text = profileData?.name ?? ""
        nameLabel.textColor = UIColor.labelColor()
        
    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(UINib(nibName: "ExpenableHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: ExpenableHeaderView.identifier)
        tableView.register(UINib(nibName: "LogoutTableViewCell", bundle: nil), forCellReuseIdentifier: LogoutTableViewCell.identifier)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.backgroundColor()
        
    }
    
    
    //MARK:- TableViewAction
    private func selectedLanguages(selectedLanguage: String){
        DataManager.shared.saveLanguage(code: selectedLanguage)
        NotificationCenter.default.post(name: Notification.Name("ChangeLanguage"), object: nil)
        DispatchQueue.main.async {
            self.setupUI()
            
        }
        
        
    }
    
    
    private func showCheckmarkLanguage(cell: UITableViewCell,indexPath: IndexPath){
        let language = DataManager.shared.getLanguage()
        print(language)
        if profileSetting[indexPath.section].isOpen == true {
            switch language {
            case "en":
                
                if indexPath.row == 0 {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
            case "vi":
                if indexPath.row == 1 {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
            default:
                break
            }
        } else {
            cell.accessoryType = .none
        }
        
    }
    
    
    private func selectedViewMode(mode: String){
        
        makeBasicCustomAlert(title: "Sorry", messaage: "Function will comming soon")
        
        //        DataManager.shared.saveViewMode(mode: mode)
        //        NotificationCenter.default.post(name: Notification.Name("ViewMode"), object: nil)
        //        DispatchQueue.main.async {
        //            self.setupUI()
        //
        //        }
        
    }
    
    private func showCheckmarkViewMode(cell: UITableViewCell,indexPath: IndexPath){
        let viewMode = DataManager.shared.getViewMode()
        if profileSetting[indexPath.section].isOpen == true {
            let allViewModeValue = ViewMode.allCases.map({$0.rawValue})
            let currentViewModeIndex = allViewModeValue.firstIndex(of: viewMode)
            if indexPath.row == currentViewModeIndex {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            
            
        } else {
            cell.accessoryType = .none
        }
        
    }
    
    
    private func showYourList(){
        let vc = ListsViewController()
        vc.transitioningDelegate = transitionDelegate
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showLibrary(librarType: LibraryType,indexPath: IndexPath){
        let vc = LibraryViewController()
        vc.libraryType = librarType
        vc.transitioningDelegate = transitionDelegate
        
        if indexPath.row == 0 {
            vc.state = .movie
            navigationController?.pushViewController(vc, animated: true)
            
        } else {
            vc.state = .tv
            navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
    
}

//MARK:- Tableview Delegate, Datasource
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate, ExpenableHeaderViewDelegate {
    func toggleSection(header: ExpenableHeaderView, section: Int) {
        //        if section < profileSetting.count - 1{
        
        if profileSetting[section].isOpen {
            header.chevronImage.image = UIImage(systemName: "chevron.right")
        } else {
            header.chevronImage.image = UIImage(systemName: "chevron.down")
        }
        profileSetting[section].isOpen = !profileSetting[section].isOpen
        tableView.beginUpdates()
        for i in 0..<profileSetting[section].option.count {
            tableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .left)
            
        }
        tableView.endUpdates()
        //        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        profileSetting.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let section = profileSetting[section]
        return section.option.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 44
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
        if indexPath.section == profileSetting.count - 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: LogoutTableViewCell.identifier, for: indexPath) as! LogoutTableViewCell
            cell.completionHandler = { 
                self.logOutControl()
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.backgroundColor = UIColor.viewBackground()
            cell.textLabel?.text = profileSetting[indexPath.section].option[indexPath.row]
            cell.textLabel?.textColor = UIColor.labelColor()
            
            //language
            if indexPath.section == 4 {
                showCheckmarkLanguage(cell: cell, indexPath: indexPath)
                //                cell.accessoryType = .checkmark
            } else if indexPath.section == 5 {
                showCheckmarkViewMode(cell: cell, indexPath: indexPath)
            } else {
                cell.accessoryType = .none
            }
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //
        
        switch indexPath.section {
        
        //Favorite
        case 0:
            showLibrary(librarType: .favorite, indexPath: indexPath)
            
        //Watch List
        case 1:
            print("")
            showLibrary(librarType: .watchlist, indexPath: indexPath)
        // Your List
        case 2:
            showYourList()
            
        //Rating
        case 3:
            showLibrary(librarType: .rate, indexPath: indexPath)
            
        //Language
        case 4:
            let selectedLanguage = self.languages[indexPath.row].languageCode        
            selectedLanguages(selectedLanguage: selectedLanguage)
            
        // view mode
        case 5:
            let selectedMode = ViewMode.allCases[indexPath.row].rawValue
            selectedViewMode(mode: selectedMode)
            
        default:
            break
        }
        
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
    }
    
}
//extension ProfileViewController: UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {
//    func navigationController(
//           _ navigationController: UINavigationController,
//        animationControllerFor operation: UINavigationController.Operation,
//           from fromVC: UIViewController,
//           to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//           
//           simpleOver.popStyle = (operation == .pop)
//           return simpleOver
//       }
//}
