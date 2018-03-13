//
//  UIViewController+Alert.swift
//  RSSReader
//
//  
//  Copyright © 2018 Denis Shvetsov. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func displayAlert(title: String?, message: String? = nil,
                      buttonTitle: String? = "OK", action: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default) { _ in
            if let action = action {
                action()
            }
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func displayInputAlert(title: String?, message: String? = nil, placeholder: String? = nil,
                           text: String? = nil, okAction: @escaping (String) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = placeholder
            textField.text = text
        })
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            if let text = alert.textFields?[0].text {
                okAction(text)
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
