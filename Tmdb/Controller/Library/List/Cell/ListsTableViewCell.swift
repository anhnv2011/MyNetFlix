//
//  WatchListTableViewCell.swift
//  Tmdb
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
    
    override func layoutSubviews() {
        super.layoutSubviews()

//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0))
    }
    func configureUI(list: Lists, poster: String?){
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.listName.text = list.name
            let have = "Have_Label".localized() + " "
            let string = String(list.itemCount ?? 0) + " "
            let item = "Items".localized() + " "
            let watch = "WatchList".localized()
            strongSelf.numberItemLabel.text = have + string + item + watch
            guard let poster = poster else {return}
                    
            let url = "\(Constant.ImageBaseUrl)\(poster)"
            strongSelf.posterImageView.loadImageUsingCache(url)
        }
        
    }
    
    
    
}
