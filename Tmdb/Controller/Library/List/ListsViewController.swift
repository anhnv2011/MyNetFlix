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

    private func setupTableView(){
        
        tableView.register(UINib(nibName: "ListsTableViewCell", bundle: nil), forCellReuseIdentifier: ListsTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.backgroundColor()

    }
    private func updateUI(){
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
    private func setupLableView(){
        view.addSubview(noListView)
        let text = "No_Label".localized() + " " + "Lists".localized()
        let title = "Create".localized() + " " + "Lists".localized()
        noListView.configure(with: ActionLabelViewModel(text: text, actionTitle: title))
        noListView.didTapCreatLibrary = {
            self.createWatchList()
        }
    }
    
    private func getLists(){
        let sessionid = DataManager.shared.getSaveSessionId()
        let profileid = DataManager.shared.getProfileId()
        APICaller.share.getLists(profileID: profileid, sessionId: sessionid) { [weak self] (result) in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let lists):
                strongSelf.lists = lists
                strongSelf.updateUI()
                
                
            case .failure(let error):
                strongSelf.makeBasicCustomAlert(title: "error", messaage: error.localizedDescription)
            }
        }
    }
    
    private func getListDetail(listID: Int, completion: @escaping (([Film]) -> Void)){
        APICaller.share.getlistDetail(listID: listID) { [weak self] (reslult) in
            guard let strongSelf = self else {return}
            switch reslult {
            case .success(let films):
                completion(films)
               
            case .failure(let error):
                strongSelf.makeBasicCustomAlert(title: "Error".localized(), messaage: error.localizedDescription)
            }
        }
    }
    
    private func createWatchList(){
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
//        let listId = list.id
        cell.configureUI(list: list)

        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
      print("asdasdasdasd")
        getListDetail(listID: lists[indexPath.row].id!) { [weak self] (films) in
            guard let strongSelf = self else {return}
            DispatchQueue.main.async {
                print("sadadadasdasdsadadasd")

                let vc = SeeAllViewController()
                vc.films = films
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            }
           
        }
        
    }
    


}
