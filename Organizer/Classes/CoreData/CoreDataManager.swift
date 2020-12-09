//
//  CoreDataManager.swift
//  Organizer
//
//  Created by Olivier Miserez on 08/12/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    static let persistentContainer = CoreDataManager().persistentContainer
    static let entityName = "Category"
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataBase")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    func getCategories(completionHandler: ([Category]) -> Void) {
        let managedContext = CoreDataManager.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Category>(entityName: CoreDataManager.entityName)
        
        do {
            let fetchedCategories = try managedContext.fetch(fetchRequest)
            completionHandler(fetchedCategories)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func deleteAllDBData() {
        let context = CoreDataManager.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Category>(entityName: CoreDataManager.entityName)
        
        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                context.delete(object)
                try context.save()
            }
            
        } catch let error {
            print("Detele all data in Defect entity error :", error)
        }
    }
}
