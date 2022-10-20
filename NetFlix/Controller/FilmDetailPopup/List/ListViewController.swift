//
//  WatchListViewController.swift
//  NetFlix
//
//  Created by MAC on 10/3/22.
//

import UIKit

class ListViewController: UIViewController {

    @IBOutlet weak var creatNewListButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dismissButton: UIButton!
    var film:Film!
    var lists = [Lists]()
    var transitionDelegate = TransitionDelegate()
    var tempList = [Lists]()
    {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getLists()
        setupUI()
        setupNotification()
        
    }
    
    //MARK:- Notification
    func setupNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(notificationReceived), name: Notification.Name("AddNewList"), object: nil)
    }
    @objc func notificationReceived(){
        
        getLists()
    }
   
    
    //MARK:- UI
    func setupUI(){
        setupTextField()
        setupTableView()

        view.backgroundColor = UIColor.viewBackground()
        creatNewListButton.setTitle("New List", for: .normal)
        let name = film.originalTitle != nil ? film.originalTitle : film.originalName
        
        statusLabel.text = "Add " + "\(name) " + "to one of your list"
        view.backgroundColor = UIColor.viewBackground()
        
    }
    func setupTableView(){
        
        tableView.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: ListTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.viewBackground()

    }
    
    func setupTextField(){
        searchTextField.delegate = self
    }
    
   //MARK:- Button action
    
    @IBAction func buttonAction(_ sender: UIButton) {
        switch sender {
        case creatNewListButton:
            creatNewList()
        case dismissButton:
            dismiss(animated: true, completion: nil)
        default:
            print("")
        }
    }
    
    func creatNewList(){
        let vc = AddNewListViewController()
        let popVc = PopupViewController(contentController: vc, popupWidth: 200, popupHeight: 200)
        popVc.transitioningDelegate = self.transitionDelegate
        popVc.modalPresentationStyle = .fullScreen
        present(popVc, animated: true, completion: nil)
    }
    
}

//MARK:- List func

extension ListViewController {
    func getLists(){
        let sessionid = DataManager.shared.getSaveSessionId()
        let profileid = DataManager.shared.getProfileId()
        APICaller.share.getLists(profileID: profileid, sessionId: sessionid) { (result) in
            switch result {
            case .success(let lists):
                
                self.lists = lists
                self.tempList = lists
                
            case .failure(let error):
                self.makeBasicCustomAlert(title: "error", messaage: error.localizedDescription)
            }
        }
    }
    
    func addTolist(listId: String, mediaId: Int){
        let sessionid = DataManager.shared.getSaveSessionId()
        APICaller.share.addFilmToList(listId: listId, mediaId: mediaId, sessionId: sessionid) {[weak self] (reponse) in
            guard let strongSelf = self else {return}
            switch reponse {
            case .success(let response):
                strongSelf.makeBasicCustomAlert(title: "\(response.status_code ?? 0)", messaage: "\(response.status_message ?? "Succses")")
                strongSelf.getLists()
                DispatchQueue.main.async {
                    strongSelf.tableView.reloadData()
                }
                
            case .failure(let error):
                strongSelf.makeBasicCustomAlert(title: "Error", messaage: error.localizedDescription)
            }
        }
    }
    
    func searchList(text: String, list:[Lists]) -> [Lists]{
        return lists.filter({ listsItems in
            (listsItems.name?.lowercased().contains(text))!
        })
    }
    
    func deleteList(listid: Int){
        let sesionid = DataManager.shared.getSaveSessionId()
        APICaller.share.deleteList(sessionID: sesionid, listID: listid) {[weak self] (reslut) in
            guard let strongSelf = self else {return}
            switch reslut {
            case .success( _):
                
                strongSelf.makeBasicCustomAlert(title: "Succes", messaage: "Delete list")
                strongSelf.getLists()
            case .failure(let error):
                strongSelf.makeBasicCustomAlert(title: "Error", messaage: error.localizedDescription)
            }
        }
    }
}
extension ListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tempList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as! ListTableViewCell
        let list = tempList[indexPath.row]
        cell.list = list
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let mediaid = Int(film.id!)
        let listid = String(tempList[indexPath.row].id!)
        addTolist(listId: listid, mediaId: mediaid)
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let listID = lists[indexPath.row].id
        let delete = UIContextualAction(style: .destructive, title: "Delete") {[weak self] (_, _, _) in
            self?.deleteList(listid: listID!)
            
        }
        let config = UISwipeActionsConfiguration(actions: [delete])
        return config
    }

}

extension ListViewController: UITextFieldDelegate{
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let text = textField.text,
           !text.isEmpty{
            tempList = searchList(text: text, list: lists)
        } else {
            tempList = lists
        }
        
    }
}
