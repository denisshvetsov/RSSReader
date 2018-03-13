//
//  FeedNetworkService.swift
//  RSSReader
//
//  
//  Copyright © 2018 Denis Shvetsov. All rights reserved.
//

import Foundation

class FeedNetworkService {
    
    // MARK: - Get
    
    func getRSSFeed(with url: String, completion: @escaping (RSSFeed?, FeedError?) -> Void) {
        self.getRSSFeedData(with: url) { data, error in
            guard let data = data else {
                completion(nil, error)
                return
            }
            let parser = RSSParser(data: data)
            if parser.parse() {
                completion(parser.feed, nil)
            } else {
                completion(nil, .wrongResponse)
            }
        }
    }
    
    private func getRSSFeedData(with url: String, completion: @escaping (Data?, FeedError?) -> Void) {
        guard let url = URL(string: url) else {
            completion(nil, .wrongURL)
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard error == nil else {
                completion(nil, .requestFailed)
                return
            }
            guard let data = data else {
                completion(nil, .emptyResponse)
                return
            }
            completion(data, nil)
        }
        task.resume()
    }
    
}
