//
//  FeedListPresenter.swift
//  RSSReader
//
//  
//  Copyright © 2018 Denis Shvetsov. All rights reserved.
//

import Foundation

class FeedListPresenter: FeedListViewOutput {
    
    weak var view: FeedListViewInput!
    
    var service = FeedService()
    
    // MARK: - FeedListViewOutput
    
    func setupView() {
        self.updateViewWithFetchedFeeds()
    }
    
    func didTapAddButton() {
        self.view.displayAddAlert()
    }
    
    func didTapAddAlertOkButton(with url: String) {
        self.service.tryToAddFeed(with: url) { error in
            if let error = error {
                self.view.displayErrorAlert(message: error.description)
            } else {
                self.updateViewWithFetchedFeeds()
            }
        }
    }
    
    func didTriggerDeleteAction(with feed: Feed) {
        self.service.delete(feed)
        self.view.deleteRow(with: feed)
    }
    
    // MARK: - Private
    
    private func updateViewWithFetchedFeeds() {
        let feeds = self.service.fetchFeeds()
        self.view.updateView(with: feeds)
    }
    
}
