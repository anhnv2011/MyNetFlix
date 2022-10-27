//
//  CarouselCollectionViewCell.swift
//  NetFlix
//
//  Created by MAC on 10/15/22.
//

import UIKit

class CarouselCollectionViewCell: UICollectionViewCell {

    static let identifier = "CarouselCollectionViewCell"
    var film: FilmItem!
    {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else {return}
                let url = "\(Constanst.ImageBaseUrl)\(strongSelf.film?.poster_path ?? "")"
                strongSelf.posterImageView.loadImageUsingCache(url)
                guard let name = strongSelf.film?.original_name != nil ? strongSelf.film?.original_name : strongSelf.film?.original_title else {return}

                strongSelf.nameLabel.text = name
            }

        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.textColor = UIColor.white
        backgroundColor = UIColor.cellBackground()
    }

}
