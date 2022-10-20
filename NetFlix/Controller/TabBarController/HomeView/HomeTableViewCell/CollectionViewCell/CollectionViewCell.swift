//
//  CollectionViewCell.swift
//  NetFlix
//
//  Created by MAC on 6/27/22.
//

import UIKit
import SDWebImage

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var posterImage: UIImageView!
    var film:Film?
    {
        didSet {
//            guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(film?.poster_path ?? "")") else {
//                return
//            }
//            posterImage.sd_setImage(with: url, completed: nil)
            let url = "https://image.tmdb.org/t/p/w500/\(film?.posterPath ?? "")"
            posterImage.loadImageUsingCache(url)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func configPosterImage(posterPath:String){
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)") else {
            return
        }
        posterImage.sd_setImage(with: url, completed: nil)
    }
}
