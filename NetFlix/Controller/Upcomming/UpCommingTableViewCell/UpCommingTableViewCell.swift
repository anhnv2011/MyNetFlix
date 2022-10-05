//
//  DetailTableViewCell.swift
//  NetFlix
//
//  Created by MAC on 6/27/22.
//

import UIKit
import SDWebImage
class UpCommingTableViewCell: UITableViewCell {
    static let identifier = "UpCommingTableViewCell"
    
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
    func configDetailMovieTableCell (posterPath: String, name: String){
        let url = "\(Constanst.ImageBaseUrl)\(posterPath)"
        detailImageView.loadImageUsingCache(url)
        nameLabel.text = name
        
    }
}
