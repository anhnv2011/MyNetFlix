//
//  SearchResultCollectionViewCell.swift
//  NetFlix
//
//  Created by MAC on 9/25/22.
//

import UIKit
import SDWebImage

class SearchResultCollectionViewCell: UICollectionViewCell {

    static let identifier = "SearchResultCollectionViewCell"
    @IBOutlet weak var imageView: UIImageView!
    var film:Film?
    {
        didSet {
            guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(film?.poster_path ?? "")") else {
                return
            }
            imageView.sd_setImage(with: url, completed: nil)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configPosterImage(posterPath:String){
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)") else {
            return
        }
        imageView.sd_setImage(with: url, completed: nil)
    }
    
}
