//
//  UIViewExtensions.swift
//  Organizer
//
//  Created by Olivier Miserez on 07/02/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    // MARK: get Current ViewController
    func getCurrentViewController() -> UIViewController? {
        let currentWindow: UIWindow? = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        
        if let sceneRootController = currentWindow {
            var currentController: UIViewController! = sceneRootController.rootViewController
            while currentController.presentedViewController != nil {
                currentController = currentController.presentedViewController
            }
            return currentController
        }
        return nil
    }
}
