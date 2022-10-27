//
//  TableSectionHeader.swift
//  NetFlix
//
//  Created by MAC on 9/28/22.
//

import UIKit

class TableSectionHeader: UITableViewHeaderFooterView {
    static let identifier = "TableSectionHeader"
    var completion: (()-> Void)?
    private let label: UILabel = {
        let label = UILabel()
        label.text = "hearder"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.semibold(ofSize: 20)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    private let seeAllButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("See all".localized(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.medium(ofSize: 20)
        button.contentHorizontalAlignment = .right
        
        //        button.titleLabel?.sizeToFit()
        return button
        
    }()
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(seeAllButton)
        contentView.backgroundColor = UIColor.sectionBackground()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        label.sizeToFit()
//        label.frame = CGRect(x: bounds.origin.x + 20, y: bounds.origin.y, width: 200, height: bounds.height)
        label.anchor(top: contentView.topAnchor, bottom: contentView.bottomAnchor, left: contentView.leftAnchor, width: 180, topPadding: 4, bottomPadding: 4, leftPadding: 8)
        seeAllButton.sizeToFit()
        seeAllButton.anchor(top: contentView.topAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, rightPadding: 8)
        seeAllButton.addTarget(self, action: #selector(seeAll), for: .touchUpInside)
    
    }
    @objc func seeAll(){
        completion!()
    }
    func configureLabel(text: String){
        label.text = text
        
    }
}
