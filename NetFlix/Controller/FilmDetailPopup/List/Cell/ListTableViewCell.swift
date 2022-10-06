//
//  ListTableViewCell.swift
//  NetFlix
//
//  Created by MAC on 10/4/22.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    static let identifier = "ListTableViewCell"
    
    @IBOutlet weak var listLabel: UILabel!
    
    var list: Lists!
    {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self!.listLabel.text = self!.list.name! + "( have \(self!.list.itemCount ?? 0) item )"
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.viewBackground()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
