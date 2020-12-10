//
//  ItemViewModel.swift
//  Organizer
//
//  Created by Olivier Miserez on 10/12/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ItemListViewModel {
    
    var category: Category
    var itemViewModels: [itemViewModel]
    
    init(category: Category) {
        self.itemViewModels = [itemViewModel]()
        self.category = category
        
        fetchItems(withCategory: category)
    }
    
    func fetchItems(withCategory: Category) {
        self.itemViewModels = []
        
        CoreDataManager.shared.getItems(from: category) { items in
            items.forEach { (item) in
                let viewModel = itemViewModel(item: item)
                self.itemViewModels.append(viewModel)
            }
        }
        
    }
    
    func addItemViewModel(_ vm: itemViewModel) {
        self.itemViewModels.append(vm)
    }
}

extension ItemListViewModel {
    
    func itemViewModels(at index: Int) -> itemViewModel {
        return self.itemViewModels[index]
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

struct itemViewModel {
    let item: Item
}

extension itemViewModel {
    
    var name: String {
        return self.item.name
    }
    
    var storageNumber: String {
        return self.item.storageNumber
    }
    
    var storagePlace: String {
        return self.item.storagePlace
    }
    
    var borrowed: Bool {
        return self.item.borrowed
    }
    
    var borrowedBy: String? {
        return self.item.borrowedBy
    }
    
    var category: Category {
        return self.item.category
    }
    
    var extraSubTitle: String? {
        return self.item.extraSubTitle
    }
    
    var subTitle: String? {
        return self.item.subTitle
    }
    
    var image: String? {
        return self.item.image
    }
    
}
