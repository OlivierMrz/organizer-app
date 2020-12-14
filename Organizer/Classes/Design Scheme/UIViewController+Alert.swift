//
//  UIViewController+Alert.swift
//  Organizer
//
//  Created by Olivier Miserez on 14/12/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import UIKit

extension UIViewController {
    
    enum AlertType {
        case warning
        case error(_ string: String)
    }
    
    func presentAlert(type: AlertType, completion: (() -> Void)?) {
        
        switch type {
        case .warning:
            presentWarningAlert(title: "⚠️ WARNING", text: "You are deleting ALL local data, are you sure?", completion: completion!)
        case .error(let error):
            presentErrorAlert(title: "", text: error)
        }
        
    }
    
    private func presentWarningAlert(title: String?, text: String?, completion: @escaping (() -> Void)) {
        let alertController = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "DELETE", style: .destructive, handler: { (_) in
            completion()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    private func presentErrorAlert(title: String?, text: String?) {
        let alertController = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "I'll will try again", style: .cancel, handler: nil))
    }
    
}

