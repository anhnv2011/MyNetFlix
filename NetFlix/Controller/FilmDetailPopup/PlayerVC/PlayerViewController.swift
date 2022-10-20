//
//  PlayerViewController.swift
//  NetFlix
//
//  Created by MAC on 10/5/22.
//

import UIKit
import youtube_ios_player_helper

class PlayerViewController: UIViewController {

    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var dismissButton: UIButton!
    var film:Film
    var youtubeLink: String?
    {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self!.setupPlayer()
                self!.setupUI()
            }
           
        }
    }
    
    
    init(film:Film){
//        super.init(nibName: nil, bundle: nil)
        self.film = film
        super.init(nibName: "PlayerViewController", bundle: nil)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupUI()
        setupPlayer()
        fetchData()
        
    }
    
    
    private func fetchData(){
        let name = film.originalTitle != nil ? film.originalTitle : film.originalName
        let key = name! + "Trailer"
        getYoutubeLink(filmname: key)
    }
    
    private func setupUI(){
        addPanGesture()
        view.backgroundColor = .black
        dismissButton.isHidden = true
    }
    private func addPanGesture(){
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(gestureAction))
        playerView.addGestureRecognizer(panGesture)
    }
    
    @objc func gestureAction(){
        dismiss(animated: true, completion: nil)
    }
    

    @IBAction func buttonAction(_ sender: UIButton) {
        switch sender {
        case dismissButton:
            dismiss(animated: true, completion: nil)
        default:
            print("Make IBAction ")
        }
    }
    func setupPlayer(){
//        playerView.load(withVideoId: "bsM1qdGAVbU")
        if let link = youtubeLink {
            playerView.delegate = self

            playerView!.load(withVideoId: link, playerVars: ["playsinline": 1])
        } else {
            print("not found")
        }
       
    }
    
}

extension PlayerViewController: YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.delegate = self
        playerView.playVideo()
    }
}
extension PlayerViewController{
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
