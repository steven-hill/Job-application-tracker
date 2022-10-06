//
//  CoreDataManager.swift
//  JobApplicationTracker
//
//  Created by Steven Hill on 02/10/2022.
//

import Foundation
import CoreData

class CoreDataManager {

    var context: NSManagedObjectContext {
        return CoreDataManager.manager.persistentContainer.viewContext
    }
    
    init() {
    }
    static let manager = CoreDataManager()
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "JobApplicationTrackerModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
