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
    
    //MARK:- Outlet
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    

    //MARK:- Property
    var completionHandler : (() -> Void)?
    var film: Film?{
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else {return}
                let url = "\(Constanst.ImageBaseUrl)\(strongSelf.film?.posterPath ?? "")"
                strongSelf.detailImageView.loadImageUsingCache(url)
                guard let name = strongSelf.film?.originalTitle  else {return}

                strongSelf.nameLabel.text = name
            }
        }
    }
    
  
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
    
    @IBAction func buttonAction(_ sender: UIButton) {
        switch sender {
        case playButton:
            playVideo()
        default:
            break
        
        }
        
    }
    
    
    private func playVideo(){
        
        completionHandler!()
    }
    func configDetailMovieTableCell (posterPath: String, name: String){
//        let url = "\(Constanst.ImageBaseUrl)\(posterPath)"
//        detailImageView.loadImageUsingCache(url)
//        nameLabel.text = name
        
        print(posterPath)
        print(name)
    }
}
