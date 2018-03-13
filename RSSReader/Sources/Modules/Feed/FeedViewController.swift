//
//  FeedViewController.swift
//  RSSReader
//
//  
//  Copyright © 2018 Denis Shvetsov. All rights reserved.
//

import UIKit

protocol FeedViewInput: class {
    
    func setupInitialState()
    
    func setupView(title: String)
    
    func updateView(with feedItems: [FeedItem])
    
    func showLoadingState()
    
    func showReadyState()
    
    func displayErrorAlert(message: String)
    
}

protocol FeedViewOutput {
    
    func setupView()
    
    func didTriggerRefreshAction()
    
}

class FeedViewController: UITableViewController, FeedViewInput {
    
    var moduleInput: FeedModuleInput!
    
    var output: FeedViewOutput!
    
    var displayedFeedItems: [FeedItem] = []
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let presenter = FeedPresenter()
        presenter.view = self
        self.moduleInput = presenter
        self.output = presenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.output.setupView()
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFeedItem",
            let feedScene = segue.destination as? FeedItemViewController,
            let selectedIndexPath = self.tableView.indexPathForSelectedRow {
            feedScene.moduleInput.configure(with: self.displayedFeedItems[selectedIndexPath.row])
        }
    }
    
    // MARK: - Action
    
    @IBAction func didTriggerRefreshAction(_ sender: UIRefreshControl) {
        self.output.didTriggerRefreshAction()
    }
    
    // MARK: - FeedViewInput
    
    func setupInitialState() {
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44.0
    }
    
    func setupView(title: String) {
        self.navigationItem.title = title
    }
    
    func updateView(with feedItems: [FeedItem]) {
        self.displayedFeedItems = feedItems
        self.tableView.reloadData()
    }
    
    func showLoadingState() {
        self.refreshControl?.beginRefreshing()
        if let height = self.refreshControl?.frame.size.height {
            self.tableView.setContentOffset(CGPoint(x: 0, y: -height), animated: true)
        }
    }
    
    func showReadyState() {
        self.refreshControl?.endRefreshing()
    }
    
    func displayErrorAlert(message: String) {
        self.displayAlert(title: "Error", message: message)
    }

    // MARK: UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.displayedFeedItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell", for: indexPath)
        cell.textLabel?.text = self.displayedFeedItems[indexPath.row].title
        cell.detailTextLabel?.text = self.displayedFeedItems[indexPath.row].date?.defaultFormatString
        return cell
    }

}
