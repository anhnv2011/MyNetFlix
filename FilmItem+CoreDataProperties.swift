//
//  FilmItem+CoreDataProperties.swift
//  
//
//  Created by MAC on 10/5/22.
//
//

import Foundation
import CoreData


extension FilmItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FilmItem> {
        return NSFetchRequest<FilmItem>(entityName: "FilmItem")
    }

    @NSManaged public var adult: Bool
    @NSManaged public var id: Int64
    @NSManaged public var media_type: String?
    @NSManaged public var original_language: String?
    @NSManaged public var original_name: String?
    @NSManaged public var original_title: String?
    @NSManaged public var overview: String?
    @NSManaged public var popularity: Double
    @NSManaged public var poster_path: String?
    @NSManaged public var release_date: String?
    @NSManaged public var title: String?
    @NSManaged public var video: Bool
    @NSManaged public var vote_average: Double
    @NSManaged public var vote_count: Int
    @NSManaged public var videoUrl: String?

}
extension FilmItem : Identifiable {

}
