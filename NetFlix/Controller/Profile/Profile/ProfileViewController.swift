//
//  ProfileViewController.swift
//  NetFlix
//
//  Created by MAC on 9/15/22.
//

import UIKit
import SDWebImage
enum ProfilePage:String, CaseIterable {
    case favorite = "Favorite"
    case recommendation = "Recommendation"
    case list = "Your list"
    case rating = "Ratings"
    case watchList = "Watch list"
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

    var profileSetting = [ProfileSetting]()
    var profileData: Profile?
    {
        didSet {
            DispatchQueue.main.async {
                self.setupUI()
            }
        }
    }
   
    @IBOutlet weak var avartarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        fetchData()
    }

    
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(UINib(nibName: "ExpenableHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: ExpenableHeaderView.identifier)
    }
    private func settingProfile(){
        profileSetting = [
            ProfileSetting(title: "Favarite", option: ["Movie", "Tv"], image: "person", isopen: false),
            ProfileSetting(title: "Recommendation", option: ["Movie", "Tv"], image: "person", isopen: false),
            ProfileSetting(title: "Your list", option: ["Movie", "Tv"], image: "person", isopen: false),
            ProfileSetting(title: "Ratings", option: ["Movie", "Tv"], image: "person", isopen: false)

        ]
    }
    private func fetchData(){
        settingProfile()

        self.profileData = DataManager.shared.profileData
        
    }
    func setupUI(){
        let url = URL(string: "\(Constanst.ImageBaseUrl)\(profileData?.avatar?.tmdb?.avatarPath ?? "")")
        
        avartarImageView.sd_setImage(with: url, completed: nil)
        usernameLabel.text = profileData?.username ?? ""
        nameLabel.text = profileData?.name ?? ""
        
    }

}
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
        return 2
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ExpenableHeaderView.identifier) as! ExpenableHeaderView
        header.customInit(title: profileSetting[section].title, image: profileSetting[section].image, section: section, delegate: self)
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = profileSetting[indexPath.section].option[indexPath.row]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let vc = LibraryViewController()
        if indexPath.row == 0 {
            vc.state = .movie
            navigationController?.pushViewController(vc, animated: true)

        } else {
            vc.state = .tv
            navigationController?.pushViewController(vc, animated: true)

        }
        
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
    }
    
}
