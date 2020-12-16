//
//  CategoryViewModel.swift
//  Organizer
//
//  Created by Olivier Miserez on 11/12/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

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
    
    var itemCount: String {
        if let items = self.category.items?.allObjects as? [Item] {
            if items.count == 1 {
                return "\(items.count) item"
            }
            
            return "\(items.count) items"
        } else {
            return "0 items"
        }
    }
    
}
