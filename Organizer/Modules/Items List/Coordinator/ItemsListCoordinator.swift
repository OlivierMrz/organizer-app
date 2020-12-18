//
//  ItemsListCoordinator.swift
//  Organizer
//
//  Created by Olivier Miserez on 16/12/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import UIKit

class ItemsListCoordinator: Coordinator {
    
    weak var parentCoordinator: MainCoordinator?
    var childCoordinators: [Coordinator]
    var navigationController: UINavigationController
    var presenter: UIViewController?
    
    init(navigationController: UINavigationController) {
        self.childCoordinators = [Coordinator]()
        self.navigationController = navigationController
    }
    
    func start(vm: Category) {
        let controller = ItemsViewController(category: vm)
        controller.title = vm.name.capitalized
        controller.coordinator = self
        presenter = controller
        navigationController.pushViewController(controller, animated: true)
    }
    
    func goToItemDetail(vm: ItemViewModel) {
        let child = ItemDetailCoordinator(navigationController: navigationController)
        child.start(vm: vm)
        childCoordinators.append(child)
    }
    
    func newItemTapped(controller: AddItemViewController) {
        presenter?.present(controller, animated: true, completion: nil)
    }
}
