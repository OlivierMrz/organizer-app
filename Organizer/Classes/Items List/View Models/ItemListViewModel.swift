//
//  ItemListViewModel.swift
//  Organizer
//
//  Created by Olivier Miserez on 10/12/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

class ItemListViewModel: MainViewModel {
    
    var category: Category
    var itemViewModels: [ItemViewModel]
    
    init(category: Category) {
        self.itemViewModels = [ItemViewModel]()
        self.category = category
        super.init()
        fetchItems(withCategory: category)
    }
    
    func fetchItems(withCategory: Category) {
        self.itemViewModels = []
        
        CoreDataManager.shared.getItems(from: category) { items in
            items.forEach { (item) in
                let viewModel = ItemViewModel(item: item)
                self.itemViewModels.append(viewModel)
            }
        }
        
    }
    
    func addItemViewModel(_ vm: ItemViewModel) {
        self.itemViewModels.append(vm)
    }
}

extension ItemListViewModel {
    
    func itemViewModels(at index: Int) -> ItemViewModel {
        return self.itemViewModels[index]
    }
    
    var itemCount: Int {
        return itemViewModels.isEmpty ? 1 : itemViewModels.count
    }
    
    var categoryName: String {
        return self.category.name
    }
    
    var categoryCellType: cellType {
        if let type = cellType.allCases.first(where: { ($0.rawValue == self.category.cellType) }) {
            return type
        }
        fatalError("")
    }
    
}
