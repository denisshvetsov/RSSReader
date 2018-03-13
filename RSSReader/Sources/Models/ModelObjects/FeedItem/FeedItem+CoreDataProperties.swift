//
//  FeedItem+CoreDataProperties.swift
//  RSSReader
//
//  
//  Copyright © 2018 Denis Shvetsov. All rights reserved.
//
//

import Foundation
import CoreData

extension FeedItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FeedItem> {
        return NSFetchRequest<FeedItem>(entityName: "FeedItem")
    }

    @NSManaged public var desc: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var feed: Feed?

}
