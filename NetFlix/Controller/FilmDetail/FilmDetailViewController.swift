//
//  FilmDetailViewController.swift
//  NetFlix
//
//  Created by MAC on 9/14/22.
//

import UIKit
import StoreKit
import Cosmos

class FilmDetailViewController: UIViewController {

    @IBOutlet weak var contenView: UIView!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var posterFilmImage: UIImageView!
    @IBOutlet weak var filmNameLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    @IBOutlet weak var playButton: DetailFilmButton!
    @IBOutlet weak var downloadButton: DetailFilmButton!
    @IBOutlet weak var addtoListButton: DetailFilmButton!
    @IBOutlet weak var shareButton: DetailFilmButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
        contenView.layer.cornerRadius = 20
        setupRateStar()
        
        playButton.layer.cornerRadius = 30
        downloadButton.layer.cornerRadius = 30
        addtoListButton.layer.cornerRadius = 30
        shareButton.layer.cornerRadius = 30

    }


    private func setupRateStar(){
        //can edit star
        cosmosView.settings.updateOnTouch = true
        //fill mode
        cosmosView.settings.fillMode = .precise
        // Change the size of the stars
        cosmosView.settings.starSize = 30
    }
    func fetchData(){
        
    }

}
