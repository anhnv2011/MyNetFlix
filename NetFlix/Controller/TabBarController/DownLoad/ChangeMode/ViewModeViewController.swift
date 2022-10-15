//
//  ViewModeViewController.swift
//  NetFlix
//
//  Created by MAC on 10/15/22.
//

import UIKit

enum ViewMode: CaseIterable {
    case TableView
    case Carousel
    
    var title:String {
        switch self {
        case .TableView:
            return "Table View"
        case .Carousel:
            return "Carousel"
        }
    }
}

class ViewModeViewController: UIViewController {

    var completionHanderler: ((ViewMode) -> ())?
    @IBOutlet weak var tableView: UITableView!
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        view.transform = CGAffineTransform(translationX: 0, y: -500)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIView.animate(withDuration: 1) {
            self.view.transform = .identity
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK:- UI
    
    private func setupUI(){
        view.backgroundColor = .darkGray
        setupTableView()
    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.layer.cornerRadius = 12
        tableView.backgroundColor = .darkGray
    }
    
    
}
    //MARK:- TableView Delegate
extension ViewModeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ViewMode.allCases.count
    }
    

//
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {return UITableViewCell()}
        let text = ViewMode.allCases[indexPath.row].title
        cell.textLabel?.text = text
        cell.textLabel?.textColor = UIColor.labelColor()
        cell.textLabel?.textAlignment = .right
        cell.backgroundColor = UIColor.darkGray
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        completionHanderler!(ViewMode.allCases[indexPath.row])
        dismiss(animated: true, completion: nil)
    }
    
}

