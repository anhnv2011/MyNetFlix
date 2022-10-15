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
    
    @IBOutlet weak var view: UIView!
    var film: Film?{
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else {return}
                let url = "\(Constanst.ImageBaseUrl)\(strongSelf.film?.poster_path ?? "")"
                strongSelf.detailImageView.loadImageUsingCache(url)
                guard let name = strongSelf.film?.original_name != nil ? strongSelf.film?.original_name : strongSelf.film?.original_title else {return}

                strongSelf.nameLabel.text = name
            }
        }
    }
    
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    func setupUI(){
        view.backgroundColor = UIColor.cellBackground()
        nameLabel.textColor = UIColor.labelColor()
        playButton.tintColor = UIColor.labelColor()
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
