//
//  FilmDetailViewController.swift
//  NetFlix
//
//  Created by MAC on 9/14/22.
//

import UIKit
import StoreKit
import Cosmos
import SDWebImage

class FilmDetailPopUpViewController: UIViewController {
    
    @IBOutlet weak var contenView: UIView!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var posterFilmImage: UIImageView!
    @IBOutlet weak var filmNameLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var playButton: DetailFilmButton!
    @IBOutlet weak var downloadButton: DetailFilmButton!
    @IBOutlet weak var addtoListButton: DetailFilmButton!
    @IBOutlet weak var favoriteButton: UIView!
    @IBOutlet weak var watchListButton: UIView!
    
    
    var completion: (() -> Void)? //badgeValue
    var film:Film!
    var mediaType = ""
    var mediaId = 0
    var yourRate: Double?
    var youtubeLink : String?
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupRateStar()
        setupUI()
        fetchData()
       
    }
    func fetchData(){
        if let mediaType = film.media_type {
            self.mediaType = mediaType
            
        }
        self.mediaId = film.id
        getFavoriteList()
        getWatchList()
        getRateList()
        guard let name = film.original_name != nil ? film.original_name : film.original_title else {return}
        let key = name + "Trailer"
        
        getYoutubeLink(filmname: key)
    
        
    }
    
    //MARK:- UI
    func setupUI(){
        contenView.layer.cornerRadius = 20
        let url = "\(Constanst.ImageBaseUrl)\(film?.poster_path ?? "")"
        
        posterFilmImage.loadImageUsingCache(url)
        let name = film.original_name != nil ? film.original_name : film.original_title
        filmNameLabel.text = name
        
        let releasdate = film.release_date
        releaseDateLabel.text = releasdate
        
        let overview = film.overview
        overviewLabel.text = overview
        
        let rate = (film.vote_average)! / 2.0
        cosmosView.rating = rate
        
        
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
        cosmosView.settings.starSize = 25
        cosmosView.didFinishTouchingCosmos = { [weak self] rating in
            guard let strongSelf = self else {
                return
            }
            strongSelf.ratingFilm(rating: rating * 2)
            
        }
    }
    
    
    //MARK:- Action
    
    @IBAction func buttonAction(_ sender: UIButton) {
        
        
        switch sender {
        case dismissButton:
            dismiss(animated: true, completion: nil)
        case playButton:
            print("")
        case favoriteButton:
            
            markFavarite(mediaType: mediaType, mediaId: mediaId, type: !isFavorited)
            isFavorited = !isFavorited
        case watchListButton:
            markWatchList(mediaType: mediaType, mediaId: mediaId, type: !isWatchListed)
            isWatchListed = !isWatchListed
        case downloadButton:
            downloadFilm()
        case addtoListButton:
            listFilm()
            
            
        default:
            print("")
        }
        
    }
    
    func downloadFilm(){

        guard let youtubeLink = youtubeLink else {return}
        DataPersistenceManager.shared.downloadFilm(model: film, url: youtubeLink) {[weak self] (result) in
            guard let strongSelf = self else {return}
            switch result {
            case .success():
                NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil)
            case .failure(let error):
                strongSelf.makeAlert(title: "Error", messaage: error.localizedDescription)
            }
        }

        completion!()
        
    }
    
    func listFilm(){
        let vc = ListViewController()
        vc.film = self.film
        let popVC = PopupViewController(contentController: vc, popupWidth: 300, popupHeight: 300)
        
        present(popVC, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
}

//MARK:- Favorite function
extension FilmDetailPopUpViewController{
    func markFavarite(mediaType: String, mediaId: Int, type: Bool){
        
        APICaller.share.postFavorite(mediaType: mediaType, mediaId: mediaId, type: type) { [weak self] result in
            
            guard let strongSelf = self else {return}
            switch result {
            case .success(let response):
                strongSelf.makeAlert(title: String(response.status_code ?? 0) , messaage: response.status_message ?? "unknow")
            case .failure(let error):
                strongSelf.makeAlert(title: "Error", messaage: error.localizedDescription)
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
                    let listFavoriteID = (film.map({$0.id}))
                    let isFav = strongSelf.checkFavorite(listFav: listFavoriteID)
                    strongSelf.isFavorited = isFav
                }
            case .failure(let error):
                strongSelf.makeAlert(title: "Error", messaage: error.localizedDescription)
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
                    let listFavoriteID = (film.map({$0.id}))
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
                strongSelf.makeAlert(title: String(response.status_code ?? 0) , messaage: response.status_message ?? "unknow")
            case .failure(let error):
                strongSelf.makeAlert(title: "Error", messaage: error.localizedDescription)
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
                    let watchList = (film.map({$0.id}))
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
                    let watchList = (film.map({$0.id}))
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
        if self.film.media_type == "movie" {
            mediatype = "movies"
        } else {
            mediatype = "tv"
        }
        APICaller.share.getRate(mediaType: mediatype, profileID: profileid, sessionID: sessionid) { [weak self] (result) in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let films):
                if films.count > 0 {
                    let rateList = films.map({$0.id})
                    let isRated = strongSelf.checkRate(rate: rateList)
                    strongSelf.isRated = isRated
                    if isRated == true {
                        strongSelf.yourRate = strongSelf.takeYourRatingScore(films: films, mediaId: strongSelf.mediaId)
                    }
                }
            case .failure(let error):
                self!.makeAlert(title: "Error", messaage: error.localizedDescription)
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
        return rating ?? 0
    }
    
    func ratingFilm(rating: Double){
        let sessionid = DataManager.shared.getSaveSessionId()
        let filid = film.id
        APICaller.share.postRate(mediaType: mediaType, filmId: filid, sessionId: sessionid, value: rating) { [weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let response):
                strongSelf.makeAlert(title: "Succes", messaage: response.status_message!)
                strongSelf.yourRate = rating
            case .failure(let error):
                strongSelf.makeAlert(title: "Error", messaage: error.localizedDescription)
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
                print(video)
                strongSelf.youtubeLink = video.id.videoId
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
}
