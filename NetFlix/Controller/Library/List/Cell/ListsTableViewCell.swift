//
//  WatchListTableViewCell.swift
//  NetFlix
//
//  Created by MAC on 10/11/22.
//

import UIKit

class ListsTableViewCell: UITableViewCell {
    
    static let identifier = "WatchListTableViewCell"
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var listName: UILabel!
    @IBOutlet weak var numberItemLabel: UILabel!
    @IBOutlet weak var typeList: UILabel!
    
    
    var list: Lists?
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        
        
    }
    
    func setupUI(){
        posterImageView.layer.cornerRadius = 20
        posterImageView.alpha = 0.5
        listName.textColor = UIColor.labelColor()
        contentView.backgroundColor = UIColor.viewBackground()
        numberItemLabel.textColor = UIColor.labelColor()
        typeList.textColor = UIColor.blue
    }
    func configureUI(list: Lists){
        listName.text = list.name
        let have = "Have_Label".localized() + " "
        let string = String(list.itemCount ?? 0) + " "
        let item = "Items".localized() + " "
        let watch = "WatchList".localized()
        numberItemLabel.text = have + string + item + watch
    }
    
    
}
