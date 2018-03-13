//
//  Feed+CoreDataProperties.swift
//  RSSReader
//
//  
//  Copyright © 2018 Denis Shvetsov. All rights reserved.
//

import Foundation
import CoreData

extension Feed {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Feed> {
        return NSFetchRequest<Feed>(entityName: Feed.entityName);
    }

    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var dateAdded: NSDate?
    @NSManaged public var feedItems: NSSet?

}

// MARK: Generated accessors for feedItems
extension Feed {

    @objc(addFeedItemsObject:)
    @NSManaged public func addToFeedItems(_ value: FeedItem)

    @objc(removeFeedItemsObject:)
    @NSManaged public func removeFromFeedItems(_ value: FeedItem)

    @objc(addFeedItems:)
    @NSManaged public func addToFeedItems(_ values: NSSet)

    @objc(removeFeedItems:)
    @NSManaged public func removeFromFeedItems(_ values: NSSet)

}
