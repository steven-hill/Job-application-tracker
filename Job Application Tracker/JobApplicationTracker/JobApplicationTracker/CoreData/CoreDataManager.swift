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
    
    static let manager = CoreDataManager()
    var persistedJobs: [Job] = []
    
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
    
    // MARK: - Core Data loading method
    
    func fetchAllJobApplications(completed: @escaping (Result<[Job], Error>) -> Void) {
        let request: NSFetchRequest<Job> = Job.fetchRequest()
        do {
            persistedJobs = try context.fetch(request)
            completed(.success(persistedJobs))
        } catch {
            print("Error fetching applications: \(error)")
            completed(.failure(error))
        }
    }
    
    // MARK: - Core Data saving method
    
    func saveContext(completed: @escaping (Result<String, Error>) -> Void) {
        if context.hasChanges {
            do {
                try context.save()
                completed(.success("Success!"))
            } catch {
                let nserror = error
                completed(.failure(nserror))
            }
        }
    }
    
    // MARK: - Core Data adding new job method
    func addNewJob(newJob: Job) {
        persistedJobs.append(newJob)
    }
    
    // MARK: - Core Data editing method
    
    func editSelectedJob(editedJobCompany: String, editedJobPosition: String, editedJobLocation: String, editedJobStatus: String, editedJobNotes: String, editedJobIndex: Int) {
        fetchAllJobApplications { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let jobs):
                self.persistedJobs = jobs
            case .failure(let error):
                print(error)
            }
        }
        
        persistedJobs[editedJobIndex].company = editedJobCompany
        persistedJobs[editedJobIndex].position = editedJobPosition
        persistedJobs[editedJobIndex].location = editedJobLocation
        persistedJobs[editedJobIndex].status = editedJobStatus
        persistedJobs[editedJobIndex].notes = editedJobNotes
    }
    
    // MARK: - Core Data deleting method
    
    func delete(index: Int) {
        fetchAllJobApplications { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let jobs):
                self.persistedJobs = jobs
            case .failure(let error):
                print(error)
            }
        }
        context.delete(persistedJobs[index])
        persistedJobs.remove(at: index)
    }
    
    // MARK: - Core Data search query method
    
    func search(queryText: String, completed: @escaping (Result<[Job], Error>) -> Void) {
        let request: NSFetchRequest<Job> = Job.fetchRequest()
        request.predicate = NSPredicate(format: "company = %@", "\(queryText)")
        do {
            persistedJobs = try context.fetch(request)
            completed(.success(persistedJobs))
        } catch {
            print("Error fetching query: \(error)")
            completed(.failure(error))
        }
    }
}
