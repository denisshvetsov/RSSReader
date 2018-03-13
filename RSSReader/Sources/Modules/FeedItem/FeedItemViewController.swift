//
//  FeedItemViewController.swift
//  RSSReader
//
//  
//  Copyright © 2018 Denis Shvetsov. All rights reserved.
//

import UIKit

protocol FeedItemViewInput: class {
    
    func setupInitialState()
    
    func setScrollEnabled()
    
    func setupView(text: NSAttributedString)
    
}

protocol FeedItemViewOutput {
    
    func setupView()
    
    func didTriggerViewAppearEvent()
    
}

class FeedItemViewController: UIViewController, FeedItemViewInput {
    
    var moduleInput: FeedItemModuleInput!
    
    var output: FeedItemViewOutput!
    
    @IBOutlet var textView: UITextView!
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let presenter = FeedItemPresenter()
        presenter.view = self
        self.moduleInput = presenter
        self.output = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.output.setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.output.didTriggerViewAppearEvent()
    }
    
    // MARK: - FeedItemViewInput
    
    func setupInitialState() {
        self.textView.isEditable = false
        self.textView.isSelectable = false
        self.textView.isScrollEnabled = false
        self.textView.textContainerInset = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
    }
    
    func setScrollEnabled() {
        self.textView.isScrollEnabled = true
    }
    
    func setupView(text: NSAttributedString) {
        self.textView.attributedText = text
    }

}
