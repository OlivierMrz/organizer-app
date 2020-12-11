//
//  UIViewControllerExtensions.swift
//  Organizer
//
//  Created by Olivier Miserez on 07/02/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func pushToCategoryItemVC(category: Category, title: String, cellType: String) {
        let controller = ItemsViewController(category: category)
        controller.title = title
        navigationController?.pushViewController(controller, animated: true)
    }
}
