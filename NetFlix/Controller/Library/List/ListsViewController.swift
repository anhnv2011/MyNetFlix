//
//  WatchListViewController.swift
//  NetFlix
//
//  Created by MAC on 10/11/22.
//

import UIKit

class ListsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
   
    var transitionDelegate = TransitionDelegate()
    var lists = [Lists]()
    private let noListView = CreatLabelView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))

    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLableView()
        getLists()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        navigationController?.hidesBarsOnSwipe = false
//        navigationController?.navigationBar.prefersLargeTitles = true
        
    }

    func setupTableView(){
        
        tableView.register(UINib(nibName: "ListsTableViewCell", bundle: nil), forCellReuseIdentifier: ListsTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.backgroundColor()

    }
    func updateUI(){
        navigationController?.hidesBarsOnSwipe = false
        title = "Lists".localized()
//        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationController?.navigationItem.largeTitleDisplayMode = .never
        setupTableView()
        if lists.count > 0 {
            noListView.isHidden = true
            tableView.isHidden = false
        } else {
            noListView.isHidden = false
            tableView.isHidden = true
        }

    }
    func setupLableView(){
        view.addSubview(noListView)
        let text = "No_Label".localized() + " " + "Lists".localized()
        let title = "Create".localized() + " " + "Lists".localized()
        noListView.configure(with: ActionLabelViewModel(text: text, actionTitle: title))
        noListView.didTapCreatLibrary = {
            self.createWatchList()
        }
    }
    
    func getLists(){
        let sessionid = DataManager.shared.getSaveSessionId()
        let profileid = DataManager.shared.getProfileId()
        APICaller.share.getLists(profileID: profileid, sessionId: sessionid) { [weak self] (result) in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let lists):
                strongSelf.lists = lists
                strongSelf.updateUI()
                print(lists)
                
            case .failure(let error):
                strongSelf.makeBasicCustomAlert(title: "error", messaage: error.localizedDescription)
            }
        }
    }
    
    
    func createWatchList(){
        let vc = AddNewListViewController()
        let popVc = PopupViewController(contentController: vc, popupWidth: 200, popupHeight: 200)
        popVc.transitioningDelegate = transitioningDelegate
        popVc.modalPresentationStyle = .fullScreen
        present(popVc, animated: true, completion: nil)
    }

}
extension ListsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListsTableViewCell.identifier, for: indexPath) as! ListsTableViewCell
        let list = lists[indexPath.row]
        cell.configureUI(list: list)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = DetailWatchListViewController()

        navigationController?.pushViewController(vc, animated: true)
    }
    


}
