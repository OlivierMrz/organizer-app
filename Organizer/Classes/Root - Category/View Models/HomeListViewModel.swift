//
//  HomeListViewModel.swift
//  Organizer
//
//  Created by Olivier Miserez on 08/12/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

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
