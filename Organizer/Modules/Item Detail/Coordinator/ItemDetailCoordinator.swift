//
//  ItemDetailCoordinator.swift
//  Organizer
//
//  Created by Olivier Miserez on 17/12/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import UIKit

class ItemDetailCoordinator: Coordinator {
    
    weak var parentCoordinator: MainCoordinator?
    var childCoordinators: [Coordinator]
    var navigationController: UINavigationController
    var presenter: UIViewController?
    
    init(navigationController: UINavigationController) {
        self.childCoordinators = [Coordinator]()
        self.navigationController = navigationController
    }
    
    func start(vm: ItemViewModel) {
        let controller = ItemDetailViewController(itemViewModel: vm)
        controller.title = vm.name.capitalized
        navigationController.pushViewController(controller, animated: true)
    }
}
