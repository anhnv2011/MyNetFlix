//
//  ProfileViewController.swift
//  NetFlix
//
//  Created by MAC on 9/15/22.
//

import UIKit
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
    var isOpen: Bool = false
    init(title: String, option: [String], isopen:Bool = false) {
        self.title = title
        self.option = option
        self.isOpen = isopen
    }
}
class ProfileViewController: UIViewController {

    var profileSetting = [ProfileSetting]()
    @IBOutlet weak var avartarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        setupTableView()
        settingProfile()
    }

    
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    func settingProfile(){
        profileSetting = [
            ProfileSetting(title: "favarite", option: ["Movie", "Tv"]),
            ProfileSetting(title: "Recommendation", option: ["Movie", "Tv"]),
            ProfileSetting(title: "Your list", option: ["Movie", "Tv"])

        ]
    }

}
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        profileSetting.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = profileSetting[section]
        if section.isOpen {
            return section.option.count + 1
            
        } else {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if indexPath.row == 0 {
          
            cell.textLabel?.text = profileSetting[indexPath.section].title
            cell.backgroundColor = .darkGray
            return cell
        } else {
            cell.textLabel?.text = profileSetting[indexPath.section].option[indexPath.row - 1]
            return cell
        }
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            profileSetting[indexPath.section].isOpen = !profileSetting[indexPath.section].isOpen
            tableView.reloadSections([indexPath.section], with: .automatic)
        } else {
            let vc = LibraryViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
       
        
    }
    
}
