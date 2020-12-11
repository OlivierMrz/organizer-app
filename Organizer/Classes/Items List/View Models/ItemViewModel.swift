//
//  ItemViewModel.swift
//  Organizer
//
//  Created by Olivier Miserez on 11/12/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

struct ItemViewModel {
    let item: Item
}

extension ItemViewModel {
    
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
