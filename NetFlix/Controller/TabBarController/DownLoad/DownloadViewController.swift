//
//  DownloadViewController.swift
//  NetFlix
//
//  Created by MAC on 6/26/22.
//

import UIKit

class DownloadViewController: UIViewController {
    
    
    //MARK:- Outlet
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var changViewModeButton: UIButton!
    @IBOutlet weak var downloadTableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var filmItems = [FilmItem]()
    var viewMode: DataViewMode = .TableView
    {
        didSet {
            self.setupUI()
        }
    }
    
    //MARK:- LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNotification()
        fetchLocalStorageForDownload()
    }
    
    var showImageIndex = [Int]()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        for view in self.navigationController?.navigationBar.subviews ?? [] {
            let subviews = view.subviews
            if subviews.count > 0, let label = subviews[0] as? UILabel {
                label.textColor = .white
            }
        }
    }
    
    func setupNotification(){
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil) { _ in
            self.fetchLocalStorageForDownload()
        }
    }
    private func fetchLocalStorageForDownload() {
        
        
        DataPersistenceManager.shared.fetchingFilmsFromDataBase { [weak self] result in
            
            
            switch result {
            case .success(let filmItems):
                print(filmItems)
                self?.filmItems = filmItems
                DispatchQueue.main.async {
                    self?.downloadTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    //MARK:- UI
    private func setupUI(){
        topView.backgroundColor = UIColor.viewBackground()
        changViewModeButton.backgroundColor = UIColor.buttonBackground()
        changViewModeButton.setTitleColor(UIColor.labelColor(), for: .normal)
        view.backgroundColor = UIColor.backgroundColor()
        if viewMode == .TableView {
            downloadTableView.isHidden = false
            collectionView.isHidden = true
        } else {
            downloadTableView.isHidden = true
            collectionView.isHidden = false
        }
        setupTableView()
        setupCollectionView()
        setupTabbar()
        setupNav()
    }
    
    
    private func setupTableView(){
        downloadTableView.dataSource = self
        downloadTableView.delegate = self
        downloadTableView.register(UINib(nibName: "UpCommingTableViewCell", bundle: nil), forCellReuseIdentifier: UpCommingTableViewCell.identifier)
        downloadTableView.tableFooterView = UIView()
    }
    func setupNav(){
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = UIColor.labelColor()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.labelColor()]
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.labelColor()]
        title = "Download".localized()
        
        
    }
    func setupTabbar(){
        if let tabItems = tabBarController?.tabBar.items {
            // modify the badge number of the third tab:
            let tabItem = tabItems[2]
            tabItem.badgeValue = nil
        }
    }
    
    
    //MARK:- Action
    @IBAction func buttonAction(_ sender: UIButton) {
        switch sender {
        case changViewModeButton:
            changeViewMode()
        default:
            break
        }
    }
    
    private func changeViewMode(){
        let vc = ViewModeViewController()
        vc.completionHanderler = { [weak self] viewmode in
            guard let strongSelf = self else {return}
            strongSelf.viewMode = viewmode
        }
        let value:CGFloat = 120
        let y = changViewModeButton.frame.size.height + 10
        let x = changViewModeButton.frame.size.width - value
        let popvc = PopupViewController(contentController: vc, position: .offsetFromView(CGPoint(x: x, y: y), changViewModeButton), popupWidth: value, popupHeight: value)
        popvc.modalPresentationStyle = .overFullScreen
        //
        present(popvc, animated: false, completion: nil)
    }
    
    func deleteData(index: Int){
        DataPersistenceManager.shared.deleteFilm(model: filmItems[index]) { [weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success():
                strongSelf.makeBasicCustomAlert(title: "Success", messaage: "Deleted")
                
            case .failure(let error):
                strongSelf.makeBasicCustomAlert(title: "Error", messaage: error.localizedDescription)
            }
            self?.filmItems.remove(at: index)
        }
    }
}


//MARK:- Table View delegate
extension DownloadViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filmItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = downloadTableView.dequeueReusableCell(withIdentifier: UpCommingTableViewCell.identifier, for: indexPath) as! UpCommingTableViewCell
        let film = filmItems[indexPath.row]
        let poster = film.poster_path
        let name = film.original_name != nil ? film.original_name : film.original_title
        cell.configDetailMovieTableCell(posterPath: poster!, name: name!)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let alert = UIAlertController(title: "Cảnh báo", message: "Are you sure?", preferredStyle: .alert)
            let deleteButton = UIAlertAction(title: "Delete", style: .destructive) { [weak self] (_) in
                guard let strongSelf = self else {return}
                strongSelf.deleteData(index: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(deleteButton)
            alert.addAction(cancelButton)
            present(alert, animated: true, completion: nil)
            
        default:
            break;
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
}

//MARK:- collection
extension DownloadViewController {
    func degreeToRadian(deg: CGFloat) -> CGFloat {
        return (deg * CGFloat.pi) / 180
    }
    
    private func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CarouselCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: CarouselCollectionViewCell.identifier)
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        //2
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.scrollDirection = .horizontal
        //3
        collectionView!.collectionViewLayout = layout
    }
    
}

extension DownloadViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filmItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCollectionViewCell.identifier, for: indexPath) as! CarouselCollectionViewCell
        cell.film = filmItems[indexPath.row]
//        cell.layer.transform = animateCell(cellFrame: cell.frame)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let collectionView = scrollView as? UICollectionView {
            for cell in collectionView.visibleCells as! [CarouselCollectionViewCell] {
                let indexPath = collectionView.indexPath(for: cell)!
                let attributes = collectionView.layoutAttributesForItem(at: indexPath)!
//                print("attributes: ", attributes)
                let cellFrame = collectionView.convert(attributes.frame, to: view)
                print("cellFrame at \(indexPath): ", cellFrame)
                
                let translationX = cellFrame.origin.x / 5
                cell.posterImageView.transform = CGAffineTransform(translationX: translationX, y: 0)
                
                cell.layer.transform = animateCell(cellFrame: cellFrame)
            }
        }
        

    }
    
     func animateCell(cellFrame: CGRect) -> CATransform3D {
        let angleFromX = Double((-cellFrame.origin.x) / 10)
        let angle = CGFloat((angleFromX * Double.pi) / 180.0)
        var transform = CATransform3DIdentity
        transform.m34 = -1.0/500 // khoang cach den mat phang chieu
        let rotation = CATransform3DRotate(transform, angle, 0, 1, 0)
        return rotation
        
//        var scaleFromX = (1000 - (cellFrame.origin.x - 200)) / 1000
//        let scaleMax: CGFloat = 1.0
//        let scaleMin: CGFloat = 0.5
//        if scaleFromX > scaleMax {
//            scaleFromX = scaleMax
//        }
//        if scaleFromX < scaleMin {
//            scaleFromX = scaleMin
//        }
//        let scale = CATransform3DScale(CATransform3DIdentity, scaleFromX, scaleFromX, 1)
//
//        return CATransform3DConcat(rotation, scale)
        
        
                
    }

}
