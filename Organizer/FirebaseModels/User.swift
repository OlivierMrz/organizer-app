//
//  User.swift
//  Organizer
//
//  Created by Olivier Miserez on 07/02/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import Firebase
import Foundation

struct User {
    let ref: DatabaseReference?
    let key: String

    let userId: String
    let isProUser: Bool
    let hasNoAds: Bool
    let canSaveImages: Bool

//    let categories: [Category]?

    init(userId: String, isProUser: Bool, hasNoAds: Bool, canSaveImages: Bool, key: String = "") {
        ref = nil
        self.key = key
        self.userId = userId
        self.isProUser = isProUser
        self.hasNoAds = hasNoAds
        self.canSaveImages = canSaveImages
//        self.categories = categories
    }

    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let userId = value["user_id"] as? String,
            let isProUser = value["is_pro_user"] as? Bool,
            let hasNoAds = value["has_no_ads"] as? Bool,
            let canSaveImages = value["can_save_images"] as? Bool else {
            return nil
        }

//        let categories = value["categories"] as? [Category]

        ref = snapshot.ref
        key = snapshot.key
        self.userId = userId
        self.isProUser = isProUser
        self.hasNoAds = hasNoAds
        self.canSaveImages = canSaveImages
//        self.categories = categories
    }

    func toAnyObject() -> Any {
        return [
            "user_id": userId,
            "is_pro_user": isProUser,
            "has_no_ads": hasNoAds,
            "can_save_images": canSaveImages
        ]
    }
}
