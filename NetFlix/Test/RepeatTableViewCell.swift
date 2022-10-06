//
//  RepeatTableViewCell.swift
//  NetFlix
//
//  Created by MAC on 10/5/22.
//

import UIKit

class RepeatTableViewCell: UITableViewCell {
    @IBOutlet weak var repeatDayLabel: UILabel!
    
    @IBOutlet weak var checkmarkImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
