//
//  NewCategory.swift
//  Organizer
//
//  Created by Olivier Miserez on 21/01/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import Firebase
import Foundation

struct NewCategory {
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

//
//    let name: String
//    let email: String
//    var message: String
//
//    init(name: String, email: String, message: String, key: String = "") {
//        ref = nil
//        self.key = key
//        self.name = name
//        self.email = email
//        self.message = message
//    }
//
//    init?(snapshot: DataSnapshot) {
//        guard
//            let value = snapshot.value as? [String: AnyObject],
//            let name = value["name"] as? String,
//            let email = value["email"] as? String,
//            let message = value["message"] as? String else {
//            return nil
//        }
//
//        ref = snapshot.ref
//        key = snapshot.key
//        self.name = name
//        self.email = email
//        self.message = message
//    }
//
//    func toAnyObject() -> Any {
//        return [
//            "name": name,
//            "email": email,
//            "message": message,
//        ]
//    }
}
