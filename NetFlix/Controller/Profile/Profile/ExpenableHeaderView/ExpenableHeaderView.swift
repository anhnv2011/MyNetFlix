//
//  ExpenableHeaderView.swift
//  NetFlix
//
//  Created by MAC on 9/27/22.
//

import Foundation
import UIKit

protocol ExpenableHeaderViewDelegate {
    func toggleSection(header: ExpenableHeaderView, section: Int)
}
class ExpenableHeaderView: UITableViewHeaderFooterView {
    static let identifier = "ExpenableHeaderView"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var sectionTitleLabel: UILabel!
    @IBOutlet weak var chevronImage: UIImageView!
    var delegate: ExpenableHeaderViewDelegate?
    
    var section: Int!
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addGesture()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addGesture()
        
    }
    
    func addGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectHeaderAction))
        self.addGestureRecognizer(tapGesture)
    }
    
    func customInit(title: String,image: String, section: Int, delegate: ExpenableHeaderViewDelegate){
        //        self.textLabel?.text = title
        self.sectionTitleLabel.text = title
        self.sectionTitleLabel.textColor = .white
        self.imageView.image = UIImage(systemName: image)
        self.imageView.tintColor = .white
        self.clipsToBounds = true
        self.section = section
        self.delegate = delegate
    }
    
    @objc func selectHeaderAction(gestureRecognizer: UITapGestureRecognizer){
        let cell = gestureRecognizer.view as! ExpenableHeaderView
        delegate?.toggleSection(header: self, section: cell.section)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}
