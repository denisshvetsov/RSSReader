//
//  FeedItemPresenter.swift
//  RSSReader
//
//  
//  Copyright © 2018 Denis Shvetsov. All rights reserved.
//

import UIKit

protocol FeedItemModuleInput {
    
    func configure(with feedItem: FeedItem)
    
}

class FeedItemPresenter: FeedItemModuleInput, FeedItemViewOutput {
    
    weak var view: FeedItemViewInput!
    
    var feedItem: FeedItem!
    
    // MARK: - FeedItemModuleInput

    func configure(with feedItem: FeedItem) {
        self.feedItem = feedItem
    }
    
    // MARK: - FeedItemViewOutput
    
    func setupView() {
        self.view.setupInitialState()
        guard let title = self.feedItem.title, let desc = self.feedItem.desc else {
            return
        }
        let text = self.attributedText(from: title, and: desc)
        self.view.setupView(text: text)
    }
    
    func didTriggerViewAppearEvent() {
        self.view.setScrollEnabled()
    }
    
    // MARK: - Private
    
    private func attributedText(from title: String, and desc: String) -> NSAttributedString {
        let titleFont = UIFont.boldSystemFont(ofSize: 20.0)
        let descFont = UIFont.systemFont(ofSize: 14.0)
        
        let text = NSMutableAttributedString()
        text.append(NSAttributedString(string: title,
                                       attributes: [NSAttributedStringKey.font : titleFont]))
        text.append(NSAttributedString(string: "\n\n"))
        text.append(NSAttributedString(string: desc,
                                       attributes: [NSAttributedStringKey.font : descFont]))
        return text
    }
}
