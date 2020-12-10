//
//  HomeViewModel.swift
//  Organizer
//
//  Created by Olivier Miserez on 08/12/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import Foundation
import CoreData

class HomeListViewModel {
    
    var categoryViewModels: [CategoryViewModel]
    
    init() {
        self.categoryViewModels = [CategoryViewModel]()
        
        fetchCategories()
    }
    
    func fetchCategories() {
        self.categoryViewModels = []
    
        CoreDataManager.shared.getCategories { (categories) in
            categories.forEach { (category) in
                let viewModel = CategoryViewModel(category: category)
                self.categoryViewModels.append(viewModel)
            }
        }
    }
    
    func addCategoryViewModel(_ vm: CategoryViewModel) {
        self.categoryViewModels.append(vm)
    }
}

extension HomeListViewModel {
    
    func categroyViewModels(at index: Int) -> CategoryViewModel {
        return self.categoryViewModels[index]
    }
    
}

struct CategoryViewModel {
    let category: Category
}

extension CategoryViewModel {
    
    var name: String {
        return self.category.name
    }
    
    var type: String {
        return self.category.cellType
    }
    
    var icon: String {
        return self.category.icon
    }
    
    var items: [Item] {
        if let items = self.category.items?.allObjects as? [Item] {
            return items
        } else {
            return []
        }
    }
    
}
