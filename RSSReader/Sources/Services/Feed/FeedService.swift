//
//  FeedService.swift
//  RSSReader
//
//  
//  Copyright © 2018 Denis Shvetsov. All rights reserved.
//

import Foundation

class FeedService {
    
    let coreDataService = FeedCoreDataService()
    let networkService = FeedNetworkService()
    
    // MARK: - Fetch
    
    func fetchFeeds() -> [Feed] {
        return self.coreDataService.fetchFeeds()
    }
    
    func fetchFeedItems(from feed: Feed) -> [FeedItem] {
        return self.coreDataService.fetchFeedItems(from: feed)
    }
    
    // MARK: - Add
    
    func tryToAddFeed(with url: String, completion: @escaping (FeedError?) -> Void) {
        if !self.coreDataService.isFeedAlreadyExist(with: url) {
            self.addFeed(with: url, completion: completion)
        } else {
            completion(.alreadyExist)
        }
    }
    
    private func addFeed(with url: String, completion: @escaping (FeedError?) -> Void) {
        self.networkService.getRSSFeed(with: url) { rssFeed, error in
            DispatchQueue.main.async { [unowned self] in
                if let rssFeed = rssFeed {
                    self.coreDataService.saveFeed(from: rssFeed, with: url)
                    completion(nil)
                } else {
                    completion(error)
                }
            }
        }
    }
    
    // MARK: - Update
    
    func update(_ feed: Feed, completion: @escaping (FeedError?) -> Void) {
        guard let url = feed.url else {
            completion(.wrongURL)
            return
        }
        self.networkService.getRSSFeed(with: url) { rssFeed, error in
            DispatchQueue.main.async { [unowned self] in
                if let rssFeed = rssFeed {
                    self.coreDataService.deleteFeedItems(from: feed)
                    self.coreDataService.saveFeedItems(from: rssFeed, with: feed)
                    completion(nil)
                } else {
                    completion(error)
                }
            }
        }
    }
    
    // MARK: - Delete

    func delete(_ feed: Feed) {
        self.coreDataService.delete(feed)
    }
}
