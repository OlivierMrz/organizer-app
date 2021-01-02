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
    
    func goToItemDetail() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let category = Category(context: context)
        category.name = "Dev Cat"
        category.cellType = cellType.basic.name
        category.icon = iconType.box.name
        
        
        
        let item = Item(context: context)
        item.borrowed = false
        item.borrowedBy = "No body"
        item.extraSubTitle = "Extra sub title"
        item.name = "Item detail"
        item.storageNumber = "A1"
        item.storagePlace = "Garage"
        item.subTitle = "Sub title"
        item.category = category
        
        category.items = NSSet(array: [item])
        
        let vm = ItemViewModel(item: item)
        let controller = ItemDetailViewController(itemViewModel: vm)
        controller.title = vm.name.capitalized
        navigationController.pushViewController(controller, animated: true)
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
