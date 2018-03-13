//
//  PredefinedFeeds.swift
//  RSSReader
//
//  
//  Copyright © 2018 Denis Shvetsov. All rights reserved.
//

import Foundation

class PredefinedFeeds {
    
    let isPredefinedFeedsAlreadyAdded = "isPredefinedFeedsAlreadyAdded"
    
    let feeds = [(title: "NYT > Home Page", url: "http://feeds.nytimes.com/nyt/rss/homepage"),
                 (title: "BBC News - World", url: "http://feeds.bbci.co.uk/news/world/rss.xml"),
                 (title: "Feed: All Latest", url: "http://feeds.wired.com/wired/index")]
    
    func addPredefinedFeeds() {
        if !UserDefaults.standard.bool(forKey: isPredefinedFeedsAlreadyAdded) {
            for feed in feeds {
                _ = Feed(title: feed.title, url: feed.url, dateAdded: NSDate())
            }
            UserDefaults.standard.set(true, forKey: isPredefinedFeedsAlreadyAdded)
        }
    }
    
}
