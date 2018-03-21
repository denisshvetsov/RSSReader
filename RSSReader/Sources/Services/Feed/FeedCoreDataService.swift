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
        let feeds = try? CoreDataService.shared.viewContext.fetch(self.feedFetchRequest(with: url))
        if let feeds = feeds, feeds.count > 0 {
            return feeds[0]
        }
        return nil
    }
    
    private func feedFetchRequest(with url: String) -> NSFetchRequest<Feed> {
        let feedFetchRequest = NSFetchRequest<Feed>(entityName: Feed.entityName)
        feedFetchRequest.predicate = NSPredicate(format: "url == %@", url)
        feedFetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateAdded", ascending: true)]
        return feedFetchRequest
    }
    
    // MARK: - Save
    
    func saveFeed(from rssFeed: RSSFeed, with url: String) {
        let feed = Feed(title: rssFeed.title, url: url, dateAdded: NSDate())
        CoreDataService.shared.saveContext()
        self.saveFeedItems(from: rssFeed, with: feed)
    }
    
    private func saveFeedItems(from rssFeed: RSSFeed, with feed: Feed) {
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
    
    private func deleteFeedItems(from feed: Feed) {
        _ = try? CoreDataService.shared.viewContext.execute(self.feedItemDeleteRequest(from: feed))
        CoreDataService.shared.saveContext()
    }
    
    private func feedItemDeleteRequest(from feed: Feed) -> NSBatchDeleteRequest {
        let feedItemFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: FeedItem.entityName)
        feedItemFetchRequest.predicate = NSPredicate(format: "%K == %@", "feed", feed)
        feedItemFetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        return NSBatchDeleteRequest(fetchRequest: feedItemFetchRequest)
    }
    
    // MARK: - Update
    
    func update(_ feed: Feed, with rssFeed: RSSFeed, completion: @escaping () -> Void) {
        CoreDataService.shared.persistentContainer.performBackgroundTask() { [unowned self] context in
            
            _ = try? context.execute(self.feedItemDeleteRequest(from: feed))
            
            guard let url = feed.url,
                let feeds = try? context.fetch(self.feedFetchRequest(with: url)),
                feeds.count > 0 else {
                return
            }
            for rssItem in rssFeed.items {
                let feedItem = FeedItem(context: context)
                feedItem.populate(from: rssItem)
                feedItem.feed = feeds[0]
            }
            
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    let nserror = error as NSError
                    print("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
            
            completion()
            
        }
    }
    
}
