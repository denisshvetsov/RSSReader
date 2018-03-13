//
//  FeedPresenter.swift
//  RSSReader
//
//  
//  Copyright © 2018 Denis Shvetsov. All rights reserved.
//

import Foundation

protocol FeedModuleInput {
    
    func configure(with feed: Feed)
    
}

class FeedPresenter: FeedModuleInput, FeedViewOutput {
    
    weak var view: FeedViewInput!
    
    var service = FeedService()
    
    var feed: Feed!
    
    // MARK: - FeedModuleInput
    
    func configure(with feed: Feed) {
        self.feed = feed
    }
    
    // MARK: - FeedViewOutput
    
    func setupView() {
        self.view.setupInitialState()
        self.view.setupView(title: self.feed.title ?? "")
        self.updateViewWithFetchedFeedItems()
        self.view.showLoadingState()
        self.updateViewWithUpdatedFeedItems()
    }
    
    func didTriggerRefreshAction() {
        self.updateViewWithUpdatedFeedItems()
    }
    
    // MARK: - Private
    
    private func updateViewWithUpdatedFeedItems() { 
        self.service.update(self.feed) { [unowned self] error in
            if let error = error {
                self.view.displayErrorAlert(message: error.description)
            } else {
                self.updateViewWithFetchedFeedItems()
            }
            self.view.showReadyState()
        }
    }
    
    private func updateViewWithFetchedFeedItems() {
        let feedItems = self.service.fetchFeedItems(from: self.feed)
        self.view.updateView(with: feedItems)
    }

}
