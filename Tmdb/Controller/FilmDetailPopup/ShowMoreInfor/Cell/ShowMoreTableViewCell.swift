//
//  ShowMoreTableViewCell.swift
//  NetFlix
//
//  Created by MAC on 10/17/22.
//

import UIKit

class ShowMoreTableViewCell: UICollectionViewCell {
    static let identifier = "ShowMoreTableViewCell"
    
    @IBOutlet weak var posterImageView: UIImageView!
    var film: Film?{
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else {return}
                let url = "\(Constanst.ImageBaseUrl)\(strongSelf.film?.posterPath ?? "")"
                strongSelf.posterImageView.loadImageUsingCache(url)
               

            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


}
