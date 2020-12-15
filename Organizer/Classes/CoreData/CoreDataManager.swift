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
    
    static let categoryEntityName = "Category"
    static let itemEntityName = "Item"
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataBase")
        
        let description = NSPersistentStoreDescription()
        description.shouldMigrateStoreAutomatically = true
        description.shouldInferMappingModelAutomatically = true
        container.persistentStoreDescriptions.append(description)
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    func saveEdited(category: Category) {
        let managedContext = CoreDataManager.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Category>(entityName: CoreDataManager.categoryEntityName)
        fetchRequest.predicate = NSPredicate(format: "name == %@", category.name)
        
        
        do {
            var item = try managedContext.fetch(fetchRequest).first!
            item = category
            try managedContext.save()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func getItemWith(name: String, completion: (Category?) -> Void) {
        let managedContext = CoreDataManager.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Category>(entityName: CoreDataManager.categoryEntityName)
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        
        do {
            let item = try managedContext.fetch(fetchRequest).first
            completion(item)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func getItems(from category: Category, completion: ([Item]) -> Void) {
        let managedContext = CoreDataManager.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Item>(entityName: CoreDataManager.itemEntityName)
        fetchRequest.predicate = NSPredicate(format: "category == %@", category)
        
        do {
            let items = try managedContext.fetch(fetchRequest)
            completion(items)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func getCategories(completionHandler: ([Category]) -> Void) {
        let managedContext = CoreDataManager.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Category>(entityName: CoreDataManager.categoryEntityName)
        
        do {
            let fetchedCategories = try managedContext.fetch(fetchRequest)
            completionHandler(fetchedCategories)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func deleteAllDBData() {
        let context = CoreDataManager.persistentContainer.viewContext
        let categoriesFetchRequest = NSFetchRequest<Category>(entityName: CoreDataManager.categoryEntityName)
        let itemsFetchRequest = NSFetchRequest<Item>(entityName: CoreDataManager.itemEntityName)
        
        do {
            let categories = try context.fetch(categoriesFetchRequest)
            let items = try context.fetch(itemsFetchRequest)
            
            for object in items {
                context.delete(object)
                try context.save()
            }
            
            for object in categories {
                context.delete(object)
                try context.save()
            }
            
        } catch let error {
            print("Detele all data in Defect entity error :", error)
        }
    }
}
