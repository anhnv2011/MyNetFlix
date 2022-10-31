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
        notificationCenter()
    }

    @IBAction func logOut(_ sender: UIButton) {
        completionHandler!()
    }
    private func setupUI(){
        logoutButton.layer.cornerRadius = 0
        logoutButton.setTitle("Log Out".localized(), for: .normal)
        logoutButton.setTitleColor(UIColor.toggleButtonColor(), for: .normal)
        logoutButton.backgroundColor = .darkGray
        backgroundColor = UIColor.cellBackground()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    private func notificationCenter(){
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: Notification.Name.changeLanguageNotiName, object: nil)
    }
    @objc func changeLanguage(){
        setupUI()
    }
}
