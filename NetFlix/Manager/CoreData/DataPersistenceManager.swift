//
//  DataPersistenceManager.swift
//  NetFlix
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
        item.id = Int64(model.id)
        item.media_type = model.media_type
        item.original_language = model.original_language
        item.original_name = model.original_name
        item.original_title = model.original_title
        item.overview = model.overview
        item.popularity = model.popularity ?? 0
        item.poster_path = model.poster_path
        item.title = model.title
        item.video = model.video ?? false
        item.vote_average = model.vote_average ?? 0
        item.vote_count = Int64(model.vote_count ?? 0)
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
