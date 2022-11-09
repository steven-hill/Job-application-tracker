//
//  CoreDataCoordinator.swift
//  JobApplicationTracker
//
//  Created by Steven Hill on 03/11/2022.
//

import Foundation
import CoreData

class CoreDataCoordinator {
    
    var context: NSManagedObjectContext {
        return CoreDataManager.manager.persistentContainer.viewContext
    }
    
    let coreDataManager = CoreDataManager()
    var jobsArray = [Job]()
    var alertMessage: String?
}

extension CoreDataCoordinator: AddNewJobViewControllerDelegate {
    func addJob(newJob: Job) {
        coreDataManager.addNewJob(newJob: newJob)
        
        coreDataManager.saveContext { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(_):
                print("Job added successfully!")
            case .failure(let error):
                print(error)
                self.alertMessage = "\(error)"
            }
        }
    }
}

extension CoreDataCoordinator: HomeViewControllerDelegate {
    
    func fetch() {
        coreDataManager.fetchAllJobApplications { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let jobs):
                self.jobsArray = jobs
            case .failure(let error):
                print(error)
                self.alertMessage = "\(error)"
            }
        }
    }
    
    func search(query: String) {
        coreDataManager.search(queryText: query) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let resultArray):
                self.jobsArray = resultArray
            case .failure(let error):
                print(error)
                self.alertMessage = "\(error)"
            }
        }
    }
}

extension CoreDataCoordinator: JobDetailViewControllerDelegate {
    
    func editJob(editedJobCompany: String, editedJobPosition: String, editedJobLocation: String, editedJobStatus: String, editedJobNotes: String, editedJobIndex: Int) {
        
        coreDataManager.editSelectedJob(editedJobCompany: editedJobCompany, editedJobPosition: editedJobPosition, editedJobLocation: editedJobLocation, editedJobStatus: editedJobStatus, editedJobNotes: editedJobNotes, editedJobIndex: editedJobIndex)
        
        coreDataManager.saveContext { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(_):
                print("Application edited successfully!")
            case .failure(let error):
                print(error)
                self.alertMessage = "\(error)"
            }
        }
    }
    
    func deleteJob(index: Int) {
        coreDataManager.delete(index: index)
        
        coreDataManager.saveContext { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(_):
                print("Application deleted successfully!")
            case .failure(let error):
                print(error)
                self.alertMessage = "\(error)"
            }
        }
    }
}
