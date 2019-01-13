//
//  CoreDataStack.swift
//  HeadyEcommerce
//
//  Created by Roshan Soni on 05/01/19.
//  Copyright © 2019 Personal. All rights reserved.
//

import Foundation
import CoreData

public final class CoreDataStack {
    static let sharedInstance = CoreDataStack()
    
    // Only allow static use, no instance creation
    private init() {}
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(
            name: "HeadyEcommerce"
        )
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var viewContext: NSManagedObjectContext = {
        let viewContext = persistentContainer.viewContext
        return viewContext
    }()
    
    lazy var privateContext: NSManagedObjectContext = {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        return context
    }()
    
    func clearPersistence(){
        do {
            try persistentContainer.managedObjectModel.entities.forEach { (entity) in
                if let name = entity.name {
                    let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: name)
                    let request = NSBatchDeleteRequest(fetchRequest: fetch)
                    try privateContext.execute(request)
                }
            }
            
            CoreDataStack.sharedInstance.saveTo(context: privateContext)
        } catch {
            print("error resenting the database: \(error.localizedDescription)")
        }
    }
    
    func saveTo(context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                preconditionFailure(error.localizedDescription)
            }
        }
    }
}


extension CoreDataStack {
    func applicationDocumentsDirectory() {
        if let url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last {
            print(url.absoluteString)
        }
    }
}
