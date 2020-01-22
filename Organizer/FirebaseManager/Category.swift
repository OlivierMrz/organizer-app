//
//  NewCategory.swift
//  Organizer
//
//  Created by Olivier Miserez on 21/01/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import Firebase
import Foundation

struct Category {
    let ref: DatabaseReference?
    let key: String

    let catName: String
    let icon: String
    let cellType: String

    init(catName: String, icon: String, cellType: String, key: String = "") {
        ref = nil
        self.key = key
        self.catName = catName
        self.icon = icon
        self.cellType = cellType
    }

    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let catName = value["catName"] as? String,
            let icon = value["icon"] as? String,
            let cellType = value["cellType"] as? String else {
            return nil
        }

        ref = snapshot.ref
        key = snapshot.key
        self.catName = catName
        self.icon = icon
        self.cellType = cellType
    }

    func toAnyObject() -> Any {
        return [
            "catName": catName,
            "icon": icon,
            "cellType": cellType,
        ]
    }
}
