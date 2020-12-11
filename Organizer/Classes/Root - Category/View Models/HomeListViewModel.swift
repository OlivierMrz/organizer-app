//
//  HomeListViewModel.swift
//  Organizer
//
//  Created by Olivier Miserez on 08/12/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import UIKit

class HomeListViewModel: MainViewModel {
    var categoryViewModels: [CategoryViewModel]
    
    override init() {
        categoryViewModels = [CategoryViewModel]()
        super.init()
        fetchCategories()
    }
}

extension HomeListViewModel {
    
    var categoriesCount: Int {
        return categoryViewModels.isEmpty ? 1 : categoryViewModels.count
    }
    
    var title: String {
        return "Categories"
    }
    
    var viewBackgroundColor: UIColor {
        return Color.primary
    }
    
    func categroyViewModels(at index: Int) -> CategoryViewModel {
        return self.categoryViewModels[index]
    }
    
    var canScroll: Bool {
        return true
    }
    
    var noCategories: String {
        return "No categories found"
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
