//
//  ShowMoreInforViewController.swift
//  Tmdb
//
//  Created by MAC on 10/6/22.
//

import UIKit
import youtube_ios_player_helper

class ShowMoreInforViewController: UIViewController {
    
    @IBOutlet weak var safeView: UIView!
    @IBOutlet weak var bottomSafeView: UIView!
    @IBOutlet weak var similarcollectionView: UICollectionView!
    @IBOutlet weak var playerView: YTPlayerView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    var youtubeLink: String?
    var film:Film!
    var filmItems = [FilmItem]()
    var completionShowMore: (() -> Void)? //badgeValue
    var similarFilms = [Film]()
    {
        didSet{
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else {return}
                print(strongSelf.similarFilms.count)
                strongSelf.similarcollectionView.reloadData()
            }
        }
    }
    
    var isPlayed = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        fetchData()
        
    }
    
    private func setupUI(){
        setupPlayer()
        setupCollectionView()
        setupLabel()
        setupButton()
        setupSubView()
    }
    private func setupSubView(){
        safeView.backgroundColor = UIColor.viewBackground()
        bottomSafeView.backgroundColor = UIColor.viewBackground()
//        view.backgroundColor = UIColor.viewBackground()
    }
    private func setupPlayer(){
        //        playerView.load(withVideoId: "bsM1qdGAVbU")
        if let youtubeLink = youtubeLink {
            playerView.delegate = self
            
            playerView!.load(withVideoId: youtubeLink, playerVars: ["playsinline": 1])
        } else {
            print("not found")
        }
        
    }
    
    private func setupLabel(){
        nameLabel.text = film.originalTitle != nil ? film.originalTitle : film.originalName
        overviewLabel.text = film.overview
    }
    
    private func setupButton(){
        dismissButton.setImage(UIImage(systemName: ImageName.shared.xmark), for: .normal)
        playButton.setTitle("    Play".localized(), for: .normal)
        playButton.setTitleColor(UIColor.labelColor(), for: .normal)
        playButton.backgroundColor = UIColor.buttonBackground()
        playButton.tintColor = UIColor.labelColor()
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        playButton.layer.cornerRadius = ConfigConstant.buttonCornerRadius
        
        downloadButton.setTitle("Download".localized(), for: .normal)
        downloadButton.setTitleColor(UIColor.labelColor(), for: .normal)
        downloadButton.backgroundColor = UIColor.buttonBackground()
        downloadButton.tintColor = UIColor.labelColor()
        downloadButton.setImage(UIImage(systemName: "square.and.arrow.down.fill"), for: .normal)
        downloadButton.layer.cornerRadius = ConfigConstant.buttonCornerRadius
        
        shareButton.setTitle("   Share".localized(), for: .normal)
        shareButton.setTitleColor(UIColor.labelColor(), for: .normal)
        shareButton.tintColor = UIColor.labelColor()
        shareButton.backgroundColor = UIColor.buttonBackground()
        shareButton.setImage(UIImage(systemName: "square.and.arrow.up.fill"), for: .normal)
        shareButton.layer.cornerRadius = ConfigConstant.buttonCornerRadius
    }
    func setupCollectionView(){
        similarcollectionView.register(UINib(nibName: "ShowMoreTableViewCell", bundle: nil), forCellWithReuseIdentifier: ShowMoreTableViewCell.identifier)
        
        similarcollectionView.delegate = self
        similarcollectionView.dataSource = self
        let width =
            (similarcollectionView.frame.width / 4)
        let height =
            similarcollectionView.frame.height
        //2
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        //3
        
        similarcollectionView!.collectionViewLayout = layout
    }
    func fetchData(){
        let id = film.id
        let mediaType = film.mediaType 
        APICaller.share.getSimilarFilm(mediaType: mediaType ?? "", filmID: id!) { [weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let films):
                strongSelf.similarFilms = films
            case .failure(let error):
                strongSelf.makeBasicCustomAlert(title: "Error", messaage: error.localizedDescription)
            }
            
        }
    }
    
    @IBAction func ButtonAction(_ sender: UIButton) {
        switch sender {
        case dismissButton:
            dismiss(animated: true)
        case playButton:
            playVideo()
        case shareButton:
            shareVieo()
        case downloadButton:
            downloadFilm()
        default:
            break
        }
    }
    private func playVideo(){
        if isPlayed == false {
            playerView.playVideo()
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            isPlayed.toggle()
        } else {
            playerView.pauseVideo()
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            isPlayed.toggle()
        }
    }
    private func shareVieo(){
        // Setting description
        let textShare = "Share film for friend or family"
        var linkString = ""
        if film.mediaType == "movie" {
            linkString = "themoviedb.org/movie/\(film.id!)"
        } else {
            linkString = "themoviedb.org/tv/\(film.id!)"
        }
        // Setting url
        let linkFilm : NSURL = NSURL(string: linkString)!
        
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [textShare, linkFilm], applicationActivities: nil)
        
        // This lines is for the popover you need to show in iPad
        activityViewController.popoverPresentationController?.sourceView = (self.view)
        
        // This line remove the arrow of the popover to show in iPad
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        // Pre-configuring activity items
        activityViewController.activityItemsConfiguration = [
            UIActivity.ActivityType.message
        ] as? UIActivityItemsConfigurationReading
        
        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.postToWeibo,
            UIActivity.ActivityType.print,
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.postToFlickr,
            UIActivity.ActivityType.postToVimeo,
            UIActivity.ActivityType.postToTencentWeibo,
            UIActivity.ActivityType.postToFacebook
        ]
        
        activityViewController.isModalInPresentation = true
        self.present(activityViewController, animated: true, completion: nil)
    }
    func downloadFilm(){
        
        guard let youtubeLink = youtubeLink else {return}
        
        
        DataPersistenceManager.shared.fetchingFilmsFromDataBase { [weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let filmItems):
                strongSelf.filmItems = filmItems
                if filmItems.map({Int($0.id)}).contains(strongSelf.film.id) {
                    strongSelf.makeBasicCustomAlert(title: "Error", messaage: "Already download")
                } else {
                    DataPersistenceManager.shared.downloadFilm(model: strongSelf.film, url: youtubeLink) {[weak self] (result) in
                        guard let strongSelf = self else {return}
                        switch result {
                        case .success():
                            NotificationCenter.default.post(name: NSNotification.Name.downloadNotiName, object: nil)
                            strongSelf.makeBasicCustomAlert(title: "Status", messaage: "Downloading")
                        case .failure(let error):
                            strongSelf.makeBasicCustomAlert(title: "Error", messaage: error.localizedDescription)
                        }
                    }
                }
                
            case .failure(let error):
                strongSelf.makeBasicCustomAlert(title: "Error", messaage: error.localizedDescription)
            }
        }
        
        
        
        completionShowMore!()
        
    }
    
    func getDownloadList(){
        DataPersistenceManager.shared.fetchingFilmsFromDataBase { [weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let filmItems):
                strongSelf.filmItems = filmItems
                strongSelf.fetchData()
            case .failure(let error):
                strongSelf.makeBasicCustomAlert(title: "Error", messaage: error.localizedDescription)
            }
        }
    }
}
extension ShowMoreInforViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return similarFilms.count
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = similarcollectionView.dequeueReusableCell(withReuseIdentifier: ShowMoreTableViewCell.identifier, for: indexPath) as! ShowMoreTableViewCell
        
        let film = similarFilms[indexPath.row]
        cell.film = film
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let film = similarFilms[indexPath.row]
        
        print(film)
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let collectionView = scrollView as? UICollectionView {
            for cell in collectionView.visibleCells as! [ShowMoreTableViewCell] {
                let indexPath = collectionView.indexPath(for: cell)!
                let attributes = collectionView.layoutAttributesForItem(at: indexPath)!
                //                print("attributes: ", attributes)
                let cellFrame = collectionView.convert(attributes.frame, to: view)
                //                print("cellFrame at \(indexPath): ", cellFrame)
                
                //                let translationX = cellFrame.origin.x / 5
                //                cell.posterImageView.transform = CGAffineTransform(translationX: translationX, y: 0)
                
//                let centerCellFlame = (cellFrame.origin.x + cellFrame.width) / 2.0
                let leftShinkPoint = CGFloat(30.0)
                let rightShinkPoint = view.frame.width - (cellFrame.width / 2)
                if cellFrame.origin.x <= leftShinkPoint || cellFrame.origin.x >= rightShinkPoint  {
                    cell.layer.transform = animationCell()
                } else {
                    cell.layer.transform = CATransform3DIdentity
                }
            }
        }
    }
    func animationCell() -> CATransform3D{
        let identity = CATransform3DIdentity
        let shirnk = CATransform3DScale(identity, 0.8, 0.8, 0.8)
        
        return shirnk
    }
    
}
extension ShowMoreInforViewController: YTPlayerViewDelegate {
    //    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
    //        playerView.delegate = self
    //        playerView.playVideo()
    //    }
}
