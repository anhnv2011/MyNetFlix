//
//  ShowMoreInforViewController.swift
//  NetFlix
//
//  Created by MAC on 10/6/22.
//

import UIKit
import youtube_ios_player_helper

class ShowMoreInforViewController: UIViewController {
    
    @IBOutlet weak var similarcollectionView: UICollectionView!
    @IBOutlet weak var playerView: YTPlayerView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    var youtubeLink: String?
    var film:Film!
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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        fetchData()
    }
    
    private func setupUI(){
        setupCollectionView()
        dismissButton.setImage(UIImage(systemName: ImageName.shared.xmark), for: .normal)
        
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
        guard let mediaType = film.media_type else {return}
        APICaller.share.getSimilarFilm(mediaType: mediaType, filmID: id) { [weak self] result in
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
        default:
            break
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

                let centerCellFlame = (cellFrame.origin.x + cellFrame.width) / 2.0
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
