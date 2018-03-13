//
//  FeedError.swift
//  RSSReader
//
//  
//  Copyright © 2018 Denis Shvetsov. All rights reserved.
//

import Foundation

enum FeedError: Error, CustomStringConvertible {
    case alreadyExist
    case wrongURL
    case requestFailed
    case emptyResponse
    case wrongResponse
    
    var description: String {
        switch self {
        case .alreadyExist:
            return "This feed is already exist"
        case .wrongURL:
            return "Wrong URL format"
        case .requestFailed:
            return "Request failed"
        case .emptyResponse:
            return "Empty response"
        case .wrongResponse:
            return "No feed on this URL"
        }
    }
}
