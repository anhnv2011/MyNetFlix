//
//  DownloadViewController.swift
//  NetFlix
//
//  Created by MAC on 6/26/22.
//

import UIKit

class DownloadViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let tabItems = tabBarController?.tabBar.items {
            // In this case we want to modify the badge number of the third tab:
            let tabItem = tabItems[3]
            tabItem.badgeValue = nil
        }


    }


}
