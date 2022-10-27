//
//  SeeAllCollectionViewCell.swift
//  NetFlix
//
//  Created by MAC on 10/1/22.
//

import UIKit

class SeeAllCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "SeeAllCollectionViewCell"
    
    @IBOutlet weak var posterImage: UIImageView!
    var film:Film?
    {
        didSet {
//
            let url = "https://image.tmdb.org/t/p/w500/\(film?.posterPath ?? "")"
            posterImage.loadImageUsingCache(url)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
