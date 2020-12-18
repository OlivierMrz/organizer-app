//
//  MainCoordinator.swift
//  Organizer
//
//  Created by Olivier Miserez on 16/12/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import Foundation
import UIKit

class MainCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
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
        navigationController.delegate = self
        
        let vc = HomeViewController()
        vc.coordinator = self
        presenter = vc
        navigationController.pushViewController(vc, animated: false)
    }
    
    func presentAddCategoryVc(_ controller: AddCategoryViewController) {
        presenter?.present(controller, animated: true, completion: nil)
    }
    
    func goToCategory(_ vm: CategoryViewModel) {
        let child = ItemsListCoordinator(navigationController: navigationController)
        child.start(vm: vm.category)
        child.parentCoordinator = self
        childCoordinators.append(child)
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        
        if let itemsViewController = fromViewController as? ItemsViewController {
            childDidFinish(itemsViewController.coordinator)
        }
        
        if let itemsDetailViewController = fromViewController as? ItemDetailViewController {
            childDidFinish(itemsDetailViewController.coordinator)
        }
    }
}
