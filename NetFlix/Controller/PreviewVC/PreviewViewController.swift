//
//  PreviewViewController.swift
//  NetFlix
//
//  Created by MAC on 9/20/22.
//

import UIKit
import youtube_ios_player_helper

class PreviewViewController: UIViewController {
    var name:String
    
    init(name: String){
//        super.init(nibName: nil, bundle: nil)
        self.name = name
        super.init(nibName: "PreviewViewController", bundle: nil)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    @IBOutlet weak var playerView: YTPlayerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        playerView.load(withVideoId: "bsM1qdGAVbU")
        setupPlayer()
        print(name)
    }

    func setupPlayer(){
        
        playerView.delegate = self
        playerView.load(withVideoId: "bsM1qdGAVbU", playerVars: ["playsinline": 1])
    }
    
}

extension PreviewViewController: YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
    }
}
