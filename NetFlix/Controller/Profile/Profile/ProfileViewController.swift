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
class ProfileViewController: UIViewController {

    @IBOutlet weak var avartarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }

    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    

}
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
    
    
}
