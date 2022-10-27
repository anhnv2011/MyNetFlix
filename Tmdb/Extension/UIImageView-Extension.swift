//
//  UIImageView-Extension.swift
//  Tmdb
//
//  Created by MAC on 9/30/22.
//

import Foundation
import UIKit

var imageToCache = NSCache<NSString, UIImage>()
extension UIImageView {
    func loadImageUsingCache(_ urlString: String) {
        self.image = nil
        
        if let cacheImage = imageToCache.object(forKey: NSString(string: urlString)) {
            self.image = cacheImage
        }
        
        guard let url = URL(string: urlString) else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error)
            }
            if let data = data,
               let downloadImage = UIImage(data: data){
                DispatchQueue.main.async {
                    self.image = downloadImage
                    imageToCache.setObject(downloadImage, forKey: NSString(string: urlString))
                }
            }
        }
        task.resume()
    }
}
