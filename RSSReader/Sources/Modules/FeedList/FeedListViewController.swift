//
//  FeedListViewController.swift
//  RSSReader
//
//
//  Copyright © 2018 Denis Shvetsov. All rights reserved.
//

import UIKit

protocol FeedListViewInput: class {
    
    func updateView(with feeds: [Feed])
    
    func displayAddAlert()
    
    func displayErrorAlert(message: String)
    
    func deleteRow(with feed: Feed)
    
}

protocol FeedListViewOutput {
    
    func setupView()
    
    func didTapAddButton()
    
    func didTapAddAlertOkButton(with url: String)
    
    func didTriggerDeleteAction(with feed: Feed)
    
}

class FeedListViewController: UITableViewController, FeedListViewInput {
    
    var output: FeedListViewOutput!
    
    var displayedFeeds: [Feed] = []
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let presenter = FeedListPresenter()
        presenter.view = self
        self.output = presenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.output.setupView()
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFeed",
            let feedScene = segue.destination as? FeedViewController,
            let selectedIndexPath = self.tableView.indexPathForSelectedRow {
            feedScene.moduleInput.configure(with: self.displayedFeeds[selectedIndexPath.row])
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func didTapAddButton(_ sender: UIBarButtonItem) {
        self.output.didTapAddButton()
    }
    
    // MARK: - FeedListViewInput
    
    func updateView(with feeds: [Feed]) {
        self.displayedFeeds = feeds
        self.tableView.reloadData()
    }
    
    func displayAddAlert() {
        self.displayInputAlert(title: "Add new feed", message: "Enter the RSS feed URL",
                               placeholder: "URL", text: "http://") { text in
                                self.output.didTapAddAlertOkButton(with: text)
        }
    }
    
    func displayErrorAlert(message: String) {
        self.displayAlert(title: "Error", message: message)
    }
    
    func deleteRow(with feed: Feed) {
        if let index = self.displayedFeeds.index(of: feed) {
            self.displayedFeeds.remove(at: index)
            self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.displayedFeeds.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedListTableViewCell", for: indexPath)
        cell.textLabel?.text = self.displayedFeeds[indexPath.row].title
        cell.detailTextLabel?.text = self.displayedFeeds[indexPath.row].url
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.output.didTriggerDeleteAction(with: self.displayedFeeds[indexPath.row])
        }
    }

}
