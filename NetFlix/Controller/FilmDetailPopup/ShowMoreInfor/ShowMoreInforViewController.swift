//
//  ShowMoreInforViewController.swift
//  NetFlix
//
//  Created by MAC on 10/6/22.
//

import UIKit
import youtube_ios_player_helper

class ShowMoreInforViewController: UIViewController {

    @IBOutlet weak var playerView: YTPlayerView!
    
    @IBOutlet weak var dismissButton: UIButton!
    var youtubeLink: String?
    var film:Film!
    var similarFilms = [Film]()
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        fetchData()
    }

    private func setupUI(){
        dismissButton.setImage(UIImage(systemName: ImageName.shared.xmark), for: .normal)
        
    }
    func fetchData(){
        let id = film.id
        guard let mediaType = film.media_type else {return}
        APICaller.share.getSimilarFilm(mediaType: mediaType, filmID: id) { [weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let films):
                strongSelf.similarFilms = films
                print(films)
            case .failure(let error):
                strongSelf.makeAlert(title: "Error", messaage: error.localizedDescription)
            }
            
        }
    }
    
    @IBAction func ButtonAction(_ sender: UIButton) {
        switch sender {
        case dismissButton:
            dismiss(animated: true)
        default:
            break
        }
    }
    

}
