//
//  LibraryCollectionViewCellCell.swift
//  Tmdb
//
//  Created by MAC on 10/20/22.
//

import UIKit
import SDWebImage
class LibraryCollectionViewCellCell: UICollectionViewCell {
    static let identifier =  "LibraryCollectionViewCellCell"
    
    @IBOutlet weak var posterImage: UIImageView!
    var film:Film?
    {
        didSet {
//
            let url = "https://image.tmdb.org/t/p/w500/\(film?.posterPath ?? "")"
//            posterImage.loadImageUsingCache(url)
            posterImage.sd_setImage(with: URL(string: url), completed: nil)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func prepareForReuse() {
        posterImage.image = nil
    }

}
