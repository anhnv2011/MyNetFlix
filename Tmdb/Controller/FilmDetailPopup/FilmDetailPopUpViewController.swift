//
//  FilmDetailViewController.swift
//  Tmdb
//
//  Created by MAC on 9/14/22.
//

import UIKit
import StoreKit
import Cosmos
import SDWebImage

class FilmDetailPopUpViewController: UIViewController {
    
    //MARK:- Outlet
    @IBOutlet weak var contenView: UIView!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var posterFilmImage: UIImageView!
    @IBOutlet weak var filmNameLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    
    @IBOutlet weak var playLabel: UILabel!
    @IBOutlet weak var listLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!
    @IBOutlet weak var watchListLabel: UILabel!
    @IBOutlet weak var downloadLabel: UILabel!
    
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var playButton: DetailFilmButton!
    @IBOutlet weak var downloadButton: DetailFilmButton!
    @IBOutlet weak var addtoListButton: DetailFilmButton!
    @IBOutlet weak var favoriteButton: UIView!
    @IBOutlet weak var watchListButton: UIView!
    @IBOutlet weak var showMoreInforButton: UIButton!
    
    
    var completionDownload: (() -> Void)? //badgeValue
    var film:Film!
    var mediaType = ""
    var mediaId = 0
    
    var youtubeLink : String?
    
    let transitionDelegate = TransitionDelegate()

    
    //coredata
    var filmItems = [FilmItem]()
    
    {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self!.setupRateLabel()
            }
        }
    }
    
    var isFavorited:Bool = false
    {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self!.setupFavoriteButton()
            }
        }
    }
    var isWatchListed:Bool = false
    {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self!.setupWatchListButton()
            }
        }
    }
    var isRated:Bool = false
    {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self!.setupRateLabel()
            }
        }
    }
    var yourRate: Double?
    {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self!.setupRateLabel()
            }
        }
    }
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData()
       
    }
    
    //MARK:- fetchData
    func fetchData(){
        let mediaType = film.mediaType
        if mediaType != nil {
            self.mediaType = mediaType!
        }
        self.mediaId = film.id!
        
        getFavoriteList()
        getWatchList()
        getRateList()
        
        // youtube
        let name = film.originalTitle != nil ? film.originalTitle : film.originalName
        let key = name! + "Trailer"
        getYoutubeLink(filmname: key)

        
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
    //MARK:- UI
    func setupUI(){
        view.backgroundColor = UIColor.popupBackground()
        setupRateStar()
        setupLabel()
        setupPosterImage()
        setupSubView()
        
//        let rate = (film.voteAverage!) / 2.0
//        cosmosView.rating = rate
        
         
    }
    
    private func setupLabel(){
        let name = film.originalTitle != nil ? film.originalTitle : film.originalName
        filmNameLabel.text = name
        
        let releasdate = film.releaseDate
        releaseDateLabel.text = releasdate

        let overview = film.overview
        overviewLabel.text = overview
      
        rateLabel.sizeToFit()
        
        playLabel.text = "Play".localized()
        listLabel.text = "Lists".localized()
        favoriteLabel.text = "Favorite".localized()
        watchListLabel.text = "WatchList".localized()
        downloadLabel.text = "Download".localized()
    }
    
    private func setupPosterImage(){
        let url = "\(Constant.ImageBaseUrl)\(film?.posterPath ?? "")"
        posterFilmImage.loadImageUsingCache(url)
    }
    
    private func setupSubView(){
        contenView.layer.cornerRadius = 20
        contenView.backgroundColor = UIColor.viewBackground()
    }
    func setupFavoriteButton(){
        if isFavorited == false {
            favoriteButton.tintColor = .white
        } else {
            favoriteButton.tintColor = .red
        }
    }
    
    func setupWatchListButton(){
        if isWatchListed == false {
            watchListButton.tintColor = .white
        } else {
            watchListButton.tintColor = .orange
        }
    }
    
    func setupRateLabel(){
        if isRated == false {
            rateLabel.textColor = .white
            rateLabel.text = "Rate now"
        } else {
            rateLabel.textColor = .white
            rateLabel.text = "Your score:" + String(yourRate ?? 0.0)
            
        }
    }
    
    
   
    // Star
    private func setupRateStar(){
        //can edit star
        cosmosView.settings.updateOnTouch = true
        //fill mode
        cosmosView.settings.fillMode = .half
        // Change the size of the stars
        cosmosView.settings.starSize = 15
        cosmosView.didFinishTouchingCosmos = { [weak self] rating in
            guard let strongSelf = self else {
                return
            }
            strongSelf.ratingFilm(rating: rating * 2)
            
        }
        let rate = (film.voteAverage!) / 2.0
        cosmosView.rating = rate
    }
    
    
    //MARK:- Button Action
    
    @IBAction func buttonAction(_ sender: UIButton) {
        
        
        switch sender {
        case dismissButton:
            dismiss(animated: true, completion: nil)
        case playButton:
            openPlayVC()
        case favoriteButton:
//            print(mediaType)
//            print(mediaId)
            markFavarite(mediaType: mediaType, mediaId: mediaId, type: !isFavorited)
            isFavorited = !isFavorited
        case watchListButton:
            markWatchList(mediaType: mediaType, mediaId: mediaId, type: !isWatchListed)
            isWatchListed = !isWatchListed
        case downloadButton:
            downloadFilm()
        case addtoListButton:
            listFilm()
        case showMoreInforButton:
            showMore()
            
        default:
            print("")
        }
        
    }
    
    private func openPlayVC(){
        let vc = PlayerViewController(film: film)
//        vc.transitioningDelegate = self
//        vc.transitioningDelegate = transitionDelegate
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    private func downloadFilm(){

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
        
        
//        DataPersistenceManager.shared.downloadFilm(model: film, url: youtubeLink) {[weak self] (result) in
//            guard let strongSelf = self else {return}
//            switch result {
//            case .success():
//                NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil)
//            case .failure(let error):
//                strongSelf.makeAlert(title: "Error", messaage: error.localizedDescription)
//            }
//        }

        completionDownload!()
        
    }
    
    private func listFilm(){
        let vc = ListViewController()
        vc.film = self.film
        let popVC = PopupViewController(contentController: vc, popupWidth: 300, popupHeight: 300)
        popVC.transitioningDelegate = transitionDelegate
        popVC.modalPresentationStyle = .fullScreen
        present(popVC, animated: true, completion: nil)
    }
    
    
    private func showMore(){
        let vc = ShowMoreInforViewController()
        vc.transitioningDelegate = transitionDelegate
        vc.modalPresentationStyle = .fullScreen
        vc.film = self.film
        vc.youtubeLink = self.youtubeLink
        vc.completionShowMore = {
            self.completionDownload!()
        }
        present(vc, animated: true, completion: nil)
    }
    
    
    
}

//MARK:- Favorite function
extension FilmDetailPopUpViewController{
    func markFavarite(mediaType: String, mediaId: Int, type: Bool){
        
        APICaller.share.postFavorite(mediaType: mediaType, mediaId: mediaId, type: type) { [weak self] result in
            
            guard let strongSelf = self else {return}
            switch result {
            case .success(let response):
                strongSelf.makeBasicCustomAlert(title: String(response.status_code ?? 0) , messaage: response.status_message ?? "unknow")
                NotificationCenter.default.post(name: NSNotification.Name.favoriteNotiName, object: nil)
            case .failure(let error):
                strongSelf.makeBasicCustomAlert(title: "Error", messaage: error.localizedDescription)
            }
        }
    }
    
    func getFavoriteList(){
        if mediaType == "movie" {
            getmovieFavorite()
        } else {
            getTVFavorite()
        }
    }
    func getmovieFavorite(){
        let sessionid = DataManager.shared.getSaveSessionId()
        let profileid = DataManager.shared.getProfileId()
        APICaller.share.getMovieFavorite(sessonid: sessionid, profileID: profileid) { [weak self] response in
            guard let strongSelf = self else {return}
            switch response {
            case . success(let film):
                if film.count > 0 {
                    let listFavoriteID = (film.map({$0.id!}))
                    let isFav = strongSelf.checkFavorite(listFav: listFavoriteID)
                    strongSelf.isFavorited = isFav
                }
            case .failure(let error):
                strongSelf.makeBasicCustomAlert(title: "Error", messaage: error.localizedDescription)
            }
        }
    }
    func getTVFavorite(){
        let sessionid = DataManager.shared.getSaveSessionId()
        let profileid = DataManager.shared.getProfileId()
        APICaller.share.getTVFavorite(sessonid: sessionid, profileID: profileid) { [weak self] response in
            guard let strongSelf = self else {return}
            
            switch response {
            case . success(let film):
                if film.count > 0 {
                    let listFavoriteID = (film.map({$0.id!}))
                    let isFav = strongSelf.checkFavorite(listFav: listFavoriteID)
                    strongSelf.isFavorited = isFav
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func checkFavorite(listFav: [Int]) -> Bool {
        for i in listFav {
            if mediaId == i {
                return true
            }
        }
        return false
    }
}

//MARK:- WatchList function

extension FilmDetailPopUpViewController {
    
    func markWatchList(mediaType: String, mediaId: Int, type: Bool){
        APICaller.share.postWatchList(mediaType: mediaType, mediaId: mediaId, type: type) { [weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let response):
                strongSelf.makeBasicCustomAlert(title: String(response.status_code ?? 0) , messaage: response.status_message ?? "unknow")
                NotificationCenter.default.post(name: NSNotification.Name.watchListNotiName, object: nil)
            case .failure(let error):
                strongSelf.makeBasicCustomAlert(title: "Error", messaage: error.localizedDescription)
            }
        }
    }
    func getWatchList(){
        if mediaType == "movie" {
            getMovieWatchList()
        } else {
            getTVWatchList()
        }
    }
    func getMovieWatchList(){
        let sessionid = DataManager.shared.getSaveSessionId()
        let profileid = DataManager.shared.getProfileId()
        APICaller.share.getWatchList(mediaType: "movies", sessonid: sessionid, profileID: profileid) { [weak self] (response) in
            guard let strongSelf = self else {return}
            
            switch response {
            case . success(let film):
                if film.count > 0{
                    let watchList = (film.map({$0.id!}))
                    let isWathch = strongSelf.checkWatchList(watchList: watchList)
                    strongSelf.isWatchListed = isWathch
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    func getTVWatchList(){
        let sessionid = DataManager.shared.getSaveSessionId()
        let profileid = DataManager.shared.getProfileId()
        APICaller.share.getWatchList(mediaType: "tv", sessonid: sessionid, profileID: profileid) { [weak self] (response) in
            guard let strongSelf = self else {return}
            
            switch response {
            case . success(let film):
                if film.count > 0{
                    let watchList = (film.map({$0.id!}))
                    let isWathch = strongSelf.checkWatchList(watchList: watchList)
                    strongSelf.isWatchListed = isWathch
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func checkWatchList(watchList: [Int]) -> Bool {
        for i in watchList {
            if mediaId == i {
                return true
            }
        }
        return false
    }
}

//MARK:- Rate Func
extension FilmDetailPopUpViewController{
    func getRateList(){
        let sessionid = DataManager.shared.getSaveSessionId()
        let profileid = DataManager.shared.getProfileId()
        var mediatype = ""
        if self.film.mediaType == "movie" {
            mediatype = "movies"
        } else {
            mediatype = "tv"
        }
        APICaller.share.getRate(mediaType: mediatype, profileID: profileid, sessionID: sessionid) { [weak self] (result) in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let films):
                if films.count > 0 {
                    let rateList = films.map({$0.id!})
                    let isRated = strongSelf.checkRate(rate: rateList)
                    strongSelf.isRated = isRated
                    if isRated == true {
                        strongSelf.yourRate = strongSelf.takeYourRatingScore(films: films, mediaId: strongSelf.mediaId)
                    }
                }
            case .failure(let error):
                self!.makeBasicCustomAlert(title: "Error", messaage: error.localizedDescription)
            }
        }
    }
    
    func checkRate(rate: [Int]) -> Bool {
        for i in rate {
            if mediaId == i {
                return true
            }
        }
        return false
    }
    func takeYourRatingScore(films: [Film], mediaId: Int) -> Double {
        let film = films.filter({$0.id == mediaId})
        let rating = film[0].rating
        return Double(rating ?? 0)
    }
    
    func ratingFilm(rating: Double){
        let sessionid = DataManager.shared.getSaveSessionId()
        let filid = film.id!
        APICaller.share.postRate(mediaType: mediaType, filmId: filid, sessionId: sessionid, value: rating) { [weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let response):
                strongSelf.makeBasicCustomAlert(title: "Success", messaage: response.status_message!)
                strongSelf.yourRate = rating
                if strongSelf.isRated == false {
                    strongSelf.isRated.toggle()

                }
            case .failure(let error):
                strongSelf.makeBasicCustomAlert(title: "Error", messaage: error.localizedDescription)
            }
        }
    }


}

//MARK:- Youtube

extension FilmDetailPopUpViewController{
    func getYoutubeLink(filmname: String) {
        APICaller.share.getFilmLink(with: filmname) {[weak self] (result) in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let video):
                print(video.id.videoId)
                strongSelf.youtubeLink = video.id.videoId
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
}
