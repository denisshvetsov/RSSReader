//
//  FeedItem+CoreDataClass.swift
//  RSSReader
//
//  
//  Copyright © 2018 Denis Shvetsov. All rights reserved.
//
//

import Foundation
import CoreData

@objc(FeedItem)
public class FeedItem: NSManagedObject {

    static let entityName = "FeedItem"
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    convenience init(title: String, desc: String, url: String, date: NSDate?, feed: Feed) {
        self.init(entity: CoreDataService.shared.entityDescription(forName: FeedItem.entityName)!,
                  insertInto: CoreDataService.shared.viewContext)
        self.title = title
        self.desc = desc
        self.url = url
        self.date = date
        self.feed = feed
    }
    
    func populate(from rssItem: RSSItem) {
        self.title = rssItem.title
        self.desc = rssItem.desc
        self.url = rssItem.link
        self.date = rssItem.date.rssDate
    }
    
}
