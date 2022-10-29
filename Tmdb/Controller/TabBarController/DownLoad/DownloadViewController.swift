//
//  DownloadViewController.swift
//  Tmdb
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
    var viewMode: DataViewMode = .Carousel
    {
        didSet {
            self.setupUI()
        }
    }
    let width = UIScreen.main.bounds.width - 10
    var height = UIScreen.main.bounds.height
    
    //MARK:- LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNotification()
        fetchLocalStorageForDownload()
        height = UIScreen.main.bounds.height - (tabBarController?.tabBar.frame.size.height)! - (navigationController?.navigationBar.frame.maxY)! - 10
       
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
        NotificationCenter.default.addObserver(forName: NSNotification.Name.downloadNotiName, object: nil, queue: nil) { _ in
            
            self.fetchLocalStorageForDownload()
        }
    }
    private func fetchLocalStorageForDownload() {
        
        
        DataPersistenceManager.shared.fetchingFilmsFromDataBase { [weak self] result in
            
            
            switch result {
            case .success(let filmItems):
                self?.filmItems = filmItems
                print(filmItems)
                DispatchQueue.main.async {
                    self?.downloadTableView.reloadData()
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    //MARK:- UI
    private func setupUI(){
//        topView.backgroundColor = UIColor.viewBackground()
//        changViewModeButton.backgroundColor = UIColor.viewBackground()
//        changViewModeButton.setTitleColor(UIColor.labelColor(), for: .normal)
        view.backgroundColor = UIColor.backgroundColor()
        if viewMode == .TableView {
            view.backgroundColor = UIColor.backgroundColor()

            downloadTableView.isHidden = false
            collectionView.isHidden = true
        } else {
//            view.backgroundColor = UIColor.white
            downloadTableView.isHidden = true
            collectionView.isHidden = false
            
        }
        setupTableView()
        setupCollectionView()
        setupTabbar()
        setupNav()
        topView.isHidden = true
        collectionView.reloadData()
    }
    
    
    private func setupTableView(){
        downloadTableView.dataSource = self
        downloadTableView.delegate = self
        downloadTableView.register(UINib(nibName: "UpCommingTableViewCell", bundle: nil), forCellReuseIdentifier: UpCommingTableViewCell.identifier)
        downloadTableView.tableFooterView = UIView()
        downloadTableView.backgroundColor = UIColor.backgroundColor()
    }
    func setupNav(){
//
//        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationController?.navigationItem.largeTitleDisplayMode = .automatic
//        navigationController?.navigationBar.tintColor = UIColor.labelColor()
//        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.labelColor()]
//        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.labelColor()]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
       
        title = "Download".localized()
        
        
    }
    func setupTabbar(){
        if let tabItems = tabBarController?.tabBar.items {
            // modify the badge number of the third tab:
            let tabItem = tabItems[2]
            tabItem.badgeValue = nil
        }
    }
    
    
    //MARK:- Landscape, portrait
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            configUIForLandscape()
        } else {
            configUIForPortrait()
        }
        
        self.view.setNeedsUpdateConstraints()
    }
    override func updateViewConstraints() {
    
        super.updateViewConstraints()
    }
    private func configUIForLandscape(){
        viewMode = .TableView
//        view.layoutIfNeeded()
    }
    
    private func configUIForPortrait (){
        viewMode = .Carousel
//        view.layoutIfNeeded()

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
    
    private func deleteData(index: Int){
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
        cell.completionHandler = {
            
        }
        let filmItem = filmItems[indexPath.row]
        let film = Film(adult: filmItem.adult, backdropPath: "", id: Int(filmItem.id), originalLanguage: filmItem.original_language, originalName: filmItem.original_name, originalTitle: filmItem.original_title, overview: filmItem.overview, posterPath: filmItem.poster_path, mediaType: filmItem.media_type, genreIds: nil, popularity: filmItem.popularity, releaseDate: filmItem.release_date, firstAirDate: nil, voteAverage: filmItem.vote_average, voteCount: filmItem.vote_count, originCountry: nil)
        cell.film = film
//        let film = try Film(from: filmItems as! Decoder)
//        print(film)
//        let film:Film = Film(
//        let poster = film.poster_path
//        let name = film.original_name != nil ? film.original_name : film.original_title
        
//        cell.configDetailMovieTableCell(posterPath: poster!, name: name)
        cell.completionHandler = {
            let vc = PlayerViewController(film: film)
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
//
            
            let cancelAction = ActionAlert(with: "Cancel".localized(), style: .normal) {[weak self] in
                guard let strongSelf = self else {return}
                strongSelf.dismiss(animated: true, completion: nil)
            }
            let deleteAction = ActionAlert(with: "Delete".localized(), style: .destructive) {[weak self] in
                guard let strongSelf = self else {return}
                strongSelf.deleteData(index: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                strongSelf.dismiss(animated: true, completion: nil)
            }
            let alertVC = CustomAlertViewController(withTitle: "Are you sure?".localized(), message: "You will delete item".localized(), actions: [cancelAction, deleteAction], axis: .horizontal, style: .dark)
            
            alertVC.modalPresentationStyle = .overCurrentContext
            alertVC.modalTransitionStyle = .crossDissolve
            present(alertVC, animated: true, completion: nil)
            
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
//        let width = collectionView.frame.width
//        let height = collectionView.frame.height
       
        //2
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 0
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.deselectItem(at: indexPath, animated: true)
//
//        let filmItem = filmItems[indexPath.row]
//        let film = Film(adult: filmItem.adult, backdropPath: "", id: Int(filmItem.id), originalLanguage: filmItem.original_language, originalName: filmItem.original_name, originalTitle: filmItem.original_title, overview: filmItem.overview, posterPath: filmItem.poster_path, mediaType: filmItem.media_type, genreIds: nil, popularity: filmItem.popularity, releaseDate: filmItem.release_date, firstAirDate: nil, voteAverage: filmItem.vote_average, voteCount: filmItem.vote_count, originCountry: nil)
//        let vc = PlayerViewController(film: film)
//        vc.modalPresentationStyle = .fullScreen
//        present(vc, animated: true, completion: nil)
        
    }
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let config = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil) {[weak self] _ in
            
            let deleteAction = UIAction(title: "Delete".localized(), image: nil, identifier: nil, discoverabilityTitle: nil, state: .off){_ in
                    self?.deleteData(index: indexPath.row)
                    self?.fetchLocalStorageForDownload()
                    self?.dismiss(animated: true, completion: nil)
                }
                return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [deleteAction])
            }
        return config
    }
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil) {[weak self] _ in
           
            let deleteAction = UIAction(title: "Delete".localized(), image: nil, identifier: nil, discoverabilityTitle: nil, state: .off){_ in
                self?.deleteData(index: indexPath.row)
                self?.fetchLocalStorageForDownload()
                self?.dismiss(animated: true, completion: nil)
                }
                return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [deleteAction])
            }
        return config
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
