//
//  LogoutTableViewCell.swift
//  Tmdb
//
//  Created by MAC on 10/16/22.
//

import UIKit

class LogoutTableViewCell: UITableViewCell {
    static let identifier = "LogoutTableViewCell"
    
    @IBOutlet weak var logoutButton: UIButton!
    var completionHandler : (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    @IBAction func logOut(_ sender: UIButton) {
        completionHandler!()
    }
    private func setupUI(){
        logoutButton.layer.cornerRadius = 0
        logoutButton.setTitle("LogOut".localized(), for: .normal)
        logoutButton.setTitleColor(.blue, for: .normal)
        logoutButton.backgroundColor = .darkGray
        backgroundColor = UIColor.cellBackground()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
