//
//  MainCoordinator.swift
//  Organizer
//
//  Created by Olivier Miserez on 16/12/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    weak var presenter: UIViewController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    convenience init(presenter: UIViewController, navigationController: UINavigationController) {
            self.init(navigationController: navigationController)
            self.presenter = presenter
        }
    
    func start() {
        let vc = HomeViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func presentAddCategoryVc() {
        
    }
    
    func goToCategory(_ vm: CategoryViewModel) {
        let controller = ItemsViewController(category: vm.category)
        controller.title = vm.category.name.capitalized
        navigationController.pushViewController(controller, animated: true)
    }
}
