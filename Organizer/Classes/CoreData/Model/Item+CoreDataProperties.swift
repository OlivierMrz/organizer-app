//
//  Item+CoreDataProperties.swift
//  Organizer
//
//  Created by Olivier Miserez on 14/12/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var borrowed: Bool
    @NSManaged public var borrowedBy: String?
    @NSManaged public var extraSubTitle: String?
    @NSManaged public var name: String
    @NSManaged public var storageNumber: String
    @NSManaged public var storagePlace: String
    @NSManaged public var subTitle: String?
    @NSManaged public var imageData: Data?
    @NSManaged public var category: Category

}
