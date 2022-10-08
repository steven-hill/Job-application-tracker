//
//  HomeViewController.swift
//  JobApplicationTracker
//
//  Created by Steven Hill on 04/08/2022.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        showAddNewJobViewController(title: "Add new job application")
    }
    
    @IBAction func returnToAllButtonTapped(_ sender: UIButton) {
        returnToAllButton.isHidden = true
        fetchAllJobApplications()
        DispatchQueue.main.async {
            self.updateDashboard()
            self.collectionView.reloadData()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var totalApplicationsLabel: UILabel!
    @IBOutlet weak var activeApplicationsLabel: UILabel!
    @IBOutlet weak var returnToAllButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var context: NSManagedObjectContext {
        return CoreDataManager.manager.persistentContainer.viewContext
    }
    
    var jobsArray = [Job]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self
        returnToAllButton.isHidden = true
        fetchAllJobApplications()
        updateDashboard()
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func fetchAllJobApplications() {
        let request: NSFetchRequest<Job> = Job.fetchRequest()
        do {
            let persistedArray = try context.fetch(request)
            if persistedArray.count == 0 {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "No job applications are being tracked.", message: "Tap the '+' button to add one.", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Ok", style: .default) { _ in
                        self.dismiss(animated: true, completion: nil)
                    }
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                }
            }
            else {
                jobsArray = persistedArray
            }
        } catch {
            print("Error fetching items \(error)")
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "An error has occurred.", message: "Please try again.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default) { _ in
                    self.dismiss(animated: true, completion: nil)
                }
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func makeSearchQuery() {
        guard let queryText = searchBar.text, !queryText.isEmpty else {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "No text was entered.", message: "Please enter a company to search for.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default) { _ in
                    self.dismiss(animated: true, completion: nil)
                }
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
            return
        }

        let request: NSFetchRequest<Job> = Job.fetchRequest()
        request.predicate = NSPredicate(format: "company = %@", "\(queryText)")
        do {
            let results = try context.fetch(request)
            if results.count == 0 {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "No results found.", message: "Please try another query.", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Ok", style: .default) { _ in
                        self.dismiss(animated: true, completion: nil)
                    }
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                jobsArray = results
                DispatchQueue.main.async {
                    self.returnToAllButton.isHidden = false
                    self.collectionView.reloadData()
                }
            }
        } catch {
            print(error)
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "An error has occurred.", message: "Please try again.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default) { _ in
                    self.dismiss(animated: true, completion: nil)
                }
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func save() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "An error has occurred.", message: "Please try again.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default) { _ in
                    self.dismiss(animated: true, completion: nil)
                }
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func updateDashboard() {
        totalApplicationsLabel.text = String(jobsArray.count)
        
        let array = jobsArray
        let firstFilteredResult = array.filter { $0.status != "Rejection email" }
        let finalFilteredResult = firstFilteredResult.filter { $0.status != "Rejected offer" }
        activeApplicationsLabel.text = String(finalFilteredResult.count)
    }
    
    func showAddNewJobViewController(title: String) {
        let addNewJobViewController = AddNewJobViewController()
        addNewJobViewController.delegate = self
        addNewJobViewController.title = title
        
        let nav = UINavigationController(rootViewController: addNewJobViewController)
        guard let sheet = nav.sheetPresentationController else { return }
        sheet.detents = [.large()]
        sheet.preferredCornerRadius = 30
        sheet.prefersGrabberVisible = true
        present(nav, animated: true, completion: nil)
    }
    
    func showJobDetailViewController(title: String, job: Job, index: Int) {
        let jobDetailViewController = JobDetailViewController(index: index)
        jobDetailViewController.delegate = self
        jobDetailViewController.title = title
        jobDetailViewController.companyNameTextfield.text = job.company
        jobDetailViewController.positionTextfield.text = job.position
        jobDetailViewController.locationTextfield.text = job.location
        jobDetailViewController.notesTextView.text = job.notes
        
        let nav = UINavigationController(rootViewController: jobDetailViewController)
        guard let sheet = nav.sheetPresentationController else { return }
        sheet.detents = [.large()]
        sheet.preferredCornerRadius = 30
        sheet.prefersGrabberVisible = true
        present(nav, animated: true, completion: nil)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return jobsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JobCell", for: indexPath) as! JobCell
        cell.setupCell(with: jobsArray[indexPath.row])
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showJobDetailViewController(title: "Edit job application", job: jobsArray[indexPath.row], index: indexPath.row)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 148)
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        makeSearchQuery()
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}

extension HomeViewController: AddNewJobViewControllerDelegate {
    func addNewJob(_ viewController: AddNewJobViewController, addedJob: Job) {
        jobsArray.append(addedJob)
        save()
        DispatchQueue.main.async {
            self.updateDashboard()
            self.collectionView.reloadData()
        }
    }
}

extension HomeViewController: JobDetailViewControllerDelegate {
    func editJob(_ viewController: JobDetailViewController, editedJob: Job, index: Int) {
        context.delete(jobsArray[index])
        jobsArray.remove(at: index)
        save()
        jobsArray.insert(editedJob, at: index)
        save()
        DispatchQueue.main.async {
            self.updateDashboard()
            self.collectionView.reloadData()
        }
    }
    
    func deleteJob(_ viewController: JobDetailViewController, index: Int) {
        context.delete(jobsArray[index])
        jobsArray.remove(at: index)
        save()
        DispatchQueue.main.async {
            self.updateDashboard()
            self.collectionView.reloadData()
        }
    }
}
