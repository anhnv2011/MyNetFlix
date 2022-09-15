//
//  ProfileViewController.swift
//  NetFlix
//
//  Created by MAC on 9/15/22.
//

import UIKit
enum ProfilePage:String, CaseIterable {
    case addtolist = "Add To lis"
    case infor = "Information"
    case setting = "Setting"
}
class ProfileViewController: UIViewController {

    @IBOutlet weak var avartarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    func setupTableView(){
        
    }
    

}
