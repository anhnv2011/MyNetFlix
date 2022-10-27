//
//  DataPersistenceManager.swift
//  Tmdb
//
//  Created by MAC on 10/5/22.
//

import Foundation
import UIKit
import CoreData


class DataPersistenceManager {
    
    enum CoreDataError: Error {
        case failedToSaveData
        case failedToFetchData
        case failedToDeleteData
    }
    
    static let shared = DataPersistenceManager()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func downloadFilm(model: Film, url: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        let item = FilmItem(context: context)
        item.adult = model.adult ?? false
        item.id = Int64(model.id!)
        item.media_type = model.mediaType
        item.original_language = model.originalLanguage
        item.original_name = model.originalTitle
        item.original_title = model.originalTitle
        item.overview = model.overview
        item.popularity = model.popularity ?? 0
        item.poster_path = model.posterPath
        item.title = ""
        item.video = false
        item.vote_average = model.voteAverage ?? 0
        item.vote_count = Int(model.voteCount ?? 0)
        item.videoUrl = url

        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(CoreDataError.failedToSaveData))
        }
    }
    
    
    func fetchingFilmsFromDataBase(completion: @escaping (Result<[FilmItem], Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<FilmItem>
        request = FilmItem.fetchRequest()
        
        do {
            
            let films = try context.fetch(request)
            completion(.success(films))
            
        } catch {
            completion(.failure(CoreDataError.failedToFetchData))
        }
    }
    
    func deleteFilm(model: FilmItem, completion: @escaping (Result<Void, Error>)-> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        
        context.delete(model)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(CoreDataError.failedToDeleteData))
        }
    }
    
   
}
