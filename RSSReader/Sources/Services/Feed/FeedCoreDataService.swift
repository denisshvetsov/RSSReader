//
//  FeedCoreDataService.swift
//  RSSReader
//
//  
//  Copyright © 2018 Denis Shvetsov. All rights reserved.
//

import Foundation
import CoreData

class FeedCoreDataService {
    
    // MARK: - Fetch
    
    func fetchFeeds() -> [Feed] {
        let feedfetchRequest = NSFetchRequest<Feed>(entityName: Feed.entityName)
        feedfetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateAdded", ascending: true)]
        let feeds = try? CoreDataService.shared.viewContext.fetch(feedfetchRequest)
        return feeds ?? []
    }
    
    func fetchFeedItems(from feed: Feed) -> [FeedItem] {
        let feedItemFetchRequest = NSFetchRequest<FeedItem>(entityName: FeedItem.entityName)
        feedItemFetchRequest.predicate = NSPredicate(format: "%K == %@", "feed", feed)
        feedItemFetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        let feedItems = try? CoreDataService.shared.viewContext.fetch(feedItemFetchRequest)
        return feedItems ?? []
    }
    
    func isFeedAlreadyExist(with url: String) -> Bool {
        if self.fetchFeed(with: url) == nil {
            return false
        }
        return true
    }
    
    private func fetchFeed(with url: String) -> Feed? {
        let feedfetchRequest = NSFetchRequest<Feed>(entityName: Feed.entityName)
        feedfetchRequest.predicate = NSPredicate(format: "url == %@", url)
        feedfetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateAdded", ascending: true)]
        let feeds = try? CoreDataService.shared.viewContext.fetch(feedfetchRequest)
        if let feeds = feeds, feeds.count > 0 {
            return feeds[0]
        }
        return nil
    }
    
    // MARK: - Save
    
    func saveFeed(from rssFeed: RSSFeed, with url: String) {
        let feed = Feed(title: rssFeed.title, url: url, dateAdded: NSDate())
        self.saveFeedItems(from: rssFeed, with: feed)
        CoreDataService.shared.saveContext()
    }
    
    func saveFeedItems(from rssFeed: RSSFeed, with feed: Feed) {
        for rssItem in rssFeed.items {
            _ = FeedItem(title: rssItem.title,
                         desc: rssItem.desc,
                         url: rssItem.link,
                         date: rssItem.date.rssDate,
                         feed: feed)
        }
        CoreDataService.shared.saveContext()
    }
    
    // MARK: - Delete
    
    func delete(_ feed: Feed) {
        self.deleteFeedItems(from: feed)
        CoreDataService.shared.viewContext.delete(feed)
        CoreDataService.shared.saveContext()
    }
    
    func deleteFeedItems(from feed: Feed) {
        let feedItemFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: FeedItem.entityName)
        feedItemFetchRequest.predicate = NSPredicate(format: "%K == %@", "feed", feed)
        feedItemFetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        let feedItemDeleteRequest = NSBatchDeleteRequest(fetchRequest: feedItemFetchRequest)
        _ = try? CoreDataService.shared.viewContext.execute(feedItemDeleteRequest)
        CoreDataService.shared.saveContext()
    }
    
}
