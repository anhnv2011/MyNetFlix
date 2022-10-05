//
//  PreviewViewController.swift
//  NetFlix
//
//  Created by MAC on 9/20/22.
//

import UIKit
import youtube_ios_player_helper

class PreviewViewController: UIViewController {

    @IBOutlet weak var playerView: YTPlayerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        playerView.load(withVideoId: "bsM1qdGAVbU")
        setupPlayer()
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
