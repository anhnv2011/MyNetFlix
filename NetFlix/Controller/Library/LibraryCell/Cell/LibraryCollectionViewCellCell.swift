//
//  LibraryCollectionViewCellCell.swift
//  NetFlix
//
//  Created by MAC on 10/20/22.
//

import UIKit

class LibraryCollectionViewCellCell: UICollectionViewCell {
    static let identifier =  "LibraryCollectionViewCellCell"
    
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
