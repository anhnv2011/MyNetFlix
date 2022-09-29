//
//  TableSectionHeader.swift
//  NetFlix
//
//  Created by MAC on 9/28/22.
//

import UIKit

class TableSectionHeader: UITableViewHeaderFooterView {
    static let identifier = "TableSectionHeader"

    private let label: UILabel = {
        let label = UILabel()
        label.text = "hearder"
        label.font = UIFont.semibold(ofSize: 20)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.backgroundColor = .darkGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        label.sizeToFit()
        label.frame = CGRect(x: bounds.origin.x + 20, y: bounds.origin.y, width: 200, height: bounds.height)
    
    }
    func configureLabel(text: String){
        label.text = text
        
    }
}
