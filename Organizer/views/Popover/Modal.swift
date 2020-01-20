//
//  Modal.swift
//  CustomPopUpController
//
//  Created by Olivier Miserez on 13/12/2019.
//  Copyright © 2019 Olivier Miserez. All rights reserved.
//

import Foundation
import UIKit

protocol Modal {
    func show(animated:Bool)
    func dismiss(animated:Bool)
    var backgroundView:UIView {get}
    var dialogView:UIView {get set}
}

//class cardModal {
//    var modalTitle: String
//
//    init(modalTitle: String) {
//        self.modalTitle = modalTitle
//    }
//}

extension Modal where Self:UIView{
    func show(animated:Bool){
        self.backgroundView.alpha = 0

        if var topController = UIApplication.shared.topMostViewController() {

            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            topController.view.addSubview(self)
            self.dialogView.center = CGPoint(x: self.center.x, y: -(self.dialogView.frame.height))

        }
        if animated {
            UIView.animate(withDuration: 0.33, animations: {
                self.backgroundView.alpha = 0.66
            })
            UIView.animate(withDuration: 0.23, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: UIView.AnimationOptions(rawValue: 0), animations: {
                self.dialogView.center  = self.center
            }, completion: { (completed) in

            })
        }else{
            self.backgroundView.alpha = 0.66
            self.dialogView.center  = self.center
        }
    }

    func dismiss(animated:Bool){
        if animated {
            UIView.animate(withDuration: 0.33, animations: {
                self.backgroundView.alpha = 0
            }, completion: { (completed) in

            })
            UIView.animate(withDuration: 0.33, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 10, options: UIView.AnimationOptions(rawValue: 0), animations: {
                self.dialogView.center = CGPoint(x: self.center.x, y: self.frame.height + self.dialogView.frame.height/2)
            }, completion: { (completed) in
                self.removeFromSuperview()
            })
        }else{
            self.removeFromSuperview()
        }

    }
}


extension UIViewController {
    func topMostViewController() -> UIViewController {
        if self.presentedViewController == nil {
            return self
        }
        if let navigation = self.presentedViewController as? UINavigationController {
            return (navigation.visibleViewController?.topMostViewController())!
        }
        if let tab = self.presentedViewController as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        return self.presentedViewController!.topMostViewController()
    }
}

extension UIApplication {
    func topMostViewController() -> UIViewController? {
        return UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController?.topMostViewController()
//        return self.keyWindow?.rootViewController?.topMostViewController() // old one
    }
}
