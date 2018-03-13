//
//  Feed+CoreDataClass.swift
//  RSSReader
//
//  
//  Copyright © 2018 Denis Shvetsov. All rights reserved.
//

import Foundation
import CoreData

@objc(Feed)
public class Feed: NSManagedObject {
    
    static let entityName = "Feed"
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    convenience init(title: String, url: String, dateAdded: NSDate) {
        self.init(entity: CoreDataService.shared.entityDescription(forName: Feed.entityName)!,
                  insertInto: CoreDataService.shared.viewContext)
        self.title = title
        self.url = url
        self.dateAdded = dateAdded
    }

}
