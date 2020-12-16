//
//  ItemsListCoordinator.swift
//  Organizer
//
//  Created by Olivier Miserez on 16/12/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import UIKit

class ItemsListCoordinator: Coordinator {
    var childCoordinators: [Coordinator]
    var navigationController: UINavigationController
    var presenter: UIViewController?
    
    init(navigationController: UINavigationController) {
        self.childCoordinators = [Coordinator]()
        self.navigationController = navigationController
    }
    
    func start() {
        
    }
    
    func goToItemDetail(vm: ItemViewModel) {
        let vc = ItemDetailViewController(itemViewModel: vm)
        vc.title = vm.name.capitalized
        navigationController.pushViewController(vc, animated: true)
    }
}
