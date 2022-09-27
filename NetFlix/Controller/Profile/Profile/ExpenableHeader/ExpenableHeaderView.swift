//
//  ExpenableHeaderView.swift
//  NetFlix
//
//  Created by MAC on 9/26/22.
//

import UIKit

protocol ExpenableHeaderViewDelegate {
    func toggleSection(header: ExpenableHeaderView, section: Int)
}
class ExpenableHeaderView: UITableViewHeaderFooterView {

    var delegate: ExpenableHeaderViewDelegate?
    
    var section: Int!
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectHeaderAction))
        self.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func customInit(title: String, section: Int, delegate: ExpenableHeaderViewDelegate){
        self.textLabel?.text = title
        self.section = section
        self.delegate = delegate
    }
    
    @objc func selectHeaderAction(gestureRecognizer: UITapGestureRecognizer){
        let cell = gestureRecognizer.view as! ExpenableHeaderView
        delegate?.toggleSection(header: self, section: cell.section)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.textLabel?.textColor = .white
        self.contentView.backgroundColor = .darkGray
    }

}
