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
    var youtubeLink: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("player view")
       
        setupPlayer()
        setupUI()
        
    }
    
    private func setupUI(){
        view.backgroundColor = .black
        
//        let value = UIInterfaceOrientation.landscapeLeft.rawValue
//            UIDevice.current.setValue(value, forKey: "orientation")
    }
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        return .landscapeLeft
//    }
//
//    override var shouldAutorotate: Bool {
//        return true
//    }
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
        playerView.delegate = self
        playerView.load(withVideoId: youtubeLink, playerVars: ["playsinline": 1])
    }
    
}

extension PlayerViewController: YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
    }
}
