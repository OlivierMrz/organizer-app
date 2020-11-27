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
    func pushToCategoryItemVC(currentUser: User?, title: String, cellType: String) {
        guard let currentUser = currentUser else { return }
        let controller = CategoryItemViewController(user: currentUser)
        controller.title = title
        controller.currentCategoryCellType = cellType
        navigationController?.pushViewController(controller, animated: true)
    }
}
