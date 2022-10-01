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

class FilmDetailViewController: UIViewController {

    @IBOutlet weak var contenView: UIView!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var posterFilmImage: UIImageView!
    @IBOutlet weak var filmNameLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var playButton: DetailFilmButton!
    @IBOutlet weak var downloadButton: DetailFilmButton!
    @IBOutlet weak var addtoListButton: DetailFilmButton!
    @IBOutlet weak var favoriteButton: UIView!
    @IBOutlet weak var watchListButton: UIView!
    
    
    var completion: (() -> Void)?
    var film:Film!
    var mediaType = ""
    var mediaId = 0
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contenView.layer.cornerRadius = 20
        setupRateStar()
        setupUI()
        fetchData()
    
    }
    func fetchData(){
        if let mediaType = film.media_type {
            self.mediaType = mediaType
            print("\(mediaType)11111")

        }
        self.mediaId = film.id
        getFavoriteList()
        getWatchList()
    }
    func setupUI(){
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(film?.poster_path ?? "")") else {
            return
        }
        posterFilmImage.sd_setImage(with: url, completed: nil)
        let name = film.original_name != nil ? film.original_name : film.original_title
        filmNameLabel.text = name
        
        let releasdate = film.release_date
        releaseDateLabel.text = releasdate
        
        let overview = film.overview
        overviewLabel.text = overview
        
        let rate = (film.vote_average)! / 2.0
        cosmosView.rating = rate
        
        
        
    }
    
  
  
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
            print("watchList")
            markWatchList(mediaType: mediaType, mediaId: mediaId, type: !isWatchListed)
            isWatchListed = !isWatchListed
        case downloadButton:
            downloadFilm()
        case addtoListButton:
            print("")

    
        default:
            print("")
        }
        
    }
    
    func downloadFilm(){
        print("")
        completion!()
        
    }
    
    private func setupRateStar(){
        //can edit star
        cosmosView.settings.updateOnTouch = true
        //fill mode
        cosmosView.settings.fillMode = .precise
        // Change the size of the stars
        cosmosView.settings.starSize = 30
        cosmosView.didTouchCosmos = { [weak self] rating in
            self?.ratingFilm()
        }
    }
    
    func ratingFilm(){
        
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
   
    
}

//MARK:- Favorite function
extension FilmDetailViewController{
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

extension FilmDetailViewController {
    
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
