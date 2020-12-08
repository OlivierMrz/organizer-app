//
//  CategoryItem.swift
//  Organizer
//
//  Created by Olivier Miserez on 22/01/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import Foundation

struct CategoryItem {
    let key: String

    let itemName: String
    let itemSubTitle: String
    let extraSubTitle: String
    let storagePlace: String
    let storageNumber: String
    let borrowed: Bool
    let borrowedBy: String
    let imageData: String?

    init(itemName: String, itemSubTitle: String, extraSubTitle: String, storagePlace: String, storageNumber: String, borrowed: Bool, borrowedBy: String, imageData: String?, key: String = "") {
        self.key = key
        self.itemName = itemName
        self.itemSubTitle = itemSubTitle
        self.extraSubTitle = extraSubTitle
        self.storagePlace = storagePlace
        self.storageNumber = storageNumber
        self.borrowed = borrowed
        self.borrowedBy = borrowedBy
        self.imageData = imageData
    }

//    init?(snapshot: DataSnapshot) {
//        guard
//            let value = snapshot.value as? [String: AnyObject],
//            let itemName = value["item_name"] as? String,
//            let itemSubTitle = value["item_sub_title"] as? String,
//            let extraSubTitle = value["extra_sub_title"] as? String,
//            let storagePlace = value["storage_place"] as? String,
//            let storageNumber = value["storage_number"] as? String,
//            let borrowed = value["borrowed"] as? Bool,
//            let borrowedBy = value["borrowed_by"] as? String else {
//            return nil
//        }
//
//        let imageData = value["image_data"] as? String
//
//        ref = snapshot.ref
//        key = snapshot.key
//        self.itemName = itemName
//        self.itemSubTitle = itemSubTitle
//        self.extraSubTitle = extraSubTitle
//        self.storagePlace = storagePlace
//        self.storageNumber = storageNumber
//        self.borrowed = borrowed
//        self.borrowedBy = borrowedBy
//        self.imageData = imageData
//    }

    func toAnyObject() -> Any {
        return [
            "item_name": itemName,
            "item_sub_title": itemSubTitle,
            "extra_sub_title": extraSubTitle,
            "storage_place": storagePlace,
            "storage_number": storageNumber,
            "borrowed": borrowed,
            "borrowed_by": borrowedBy,
            "image_data": imageData
        ]
    }
}
