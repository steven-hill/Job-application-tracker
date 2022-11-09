//
//  HomeViewController.swift
//  JobApplicationTracker
//
//  Created by Steven Hill on 04/08/2022.
//

import UIKit
import CoreData

protocol HomeViewControllerDelegate {
    var jobsArray: [Job] { get set }
    func fetch()
    var alertMessage: String? { get set }
    func search(query: String)
}

class HomeViewController: UIViewController {
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        showAddNewJobViewController(title: "Add new job application")
    }
    
    @IBAction func returnToAllButtonTapped(_ sender: UIButton) {
        returnToAllButton.isHidden = true
        returnToAllButton.isUserInteractionEnabled = false
        delegate.jobsArray.removeAll()
        getJobApplications()
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
    
    var delegate: HomeViewControllerDelegate!
    
    init(delegate: HomeViewControllerDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self
        returnToAllButton.isHidden = true
        getJobApplications()
        updateDashboard()
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func getJobApplications() {
        delegate.fetch()
        if delegate.jobsArray.count == 0 {
            showAlert(title: "No job applications are being tracked.", message: "Tap the '+' button to add one.")
        }
        if delegate.alertMessage != nil {
            showAlert(title: "Error fetching applications.", message: "\(String(describing: self.delegate.alertMessage)).")
        }
    }
    
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default) { _ in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // TODO: - fix the editing after search bug.
    func makeSearchQuery() {
        guard let queryText = searchBar.text, !queryText.isEmpty else {
            showAlert(title: "No text was entered.", message: "Please enter a company to search for.")
            return
        }
        
        delegate.search(query: queryText)
        if delegate.jobsArray.count == 0 {
            showAlert(title: "No results found for that query.", message: "Please try another one.")
        }
        if delegate.alertMessage != nil {
            showAlert(title: "Search error.", message: "\(String(describing: self.delegate.alertMessage)).")
        }
        DispatchQueue.main.async {
            self.returnToAllButton.isHidden = false
            self.returnToAllButton.isUserInteractionEnabled = true
            self.collectionView.reloadData()
        }
    }
    
    func updateDashboard() {
        let total: Int = delegate.jobsArray.count
        totalApplicationsLabel.text = String(total)
        
        let array = delegate.jobsArray
        let firstFilteredResult = array.filter { $0.status != "Rejection email" }
        let finalFilteredResult = firstFilteredResult.filter { $0.status != "Rejected offer" }
        activeApplicationsLabel.text = String(finalFilteredResult.count)
    }
    
    func showAddNewJobViewController(title: String) {
        let addNewJobViewController = AddNewJobViewController()
        let coreDataCoordinator = CoreDataCoordinator()
        addNewJobViewController.delegate = coreDataCoordinator
        addNewJobViewController.title = title
        addNewJobViewController.reloadDelegate = self
        
        let nav = UINavigationController(rootViewController: addNewJobViewController)
        guard let sheet = nav.sheetPresentationController else { return }
        sheet.detents = [.large()]
        sheet.preferredCornerRadius = 30
        sheet.prefersGrabberVisible = true
        present(nav, animated: true, completion: nil)
    }
    
    func showJobDetailViewController(title: String, job: Job, index: Int) {
        let jobDetailViewController = JobDetailViewController(index: index)
        let coreDataCoordinator = CoreDataCoordinator()
        jobDetailViewController.delegate = coreDataCoordinator
        jobDetailViewController.title = title
        jobDetailViewController.reloadDelegate = self
        
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
        return delegate.jobsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JobCell", for: indexPath) as! JobCell
        cell.setupCell(with: delegate.jobsArray[indexPath.row])
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showJobDetailViewController(title: "Edit job application", job: delegate.jobsArray[indexPath.row], index: indexPath.row)
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

extension HomeViewController {
    func reloadCollectionView() {
        returnToAllButton.isHidden = true
        returnToAllButton.isUserInteractionEnabled = false
        delegate.jobsArray.removeAll()
        getJobApplications()
        DispatchQueue.main.async {
            self.updateDashboard()
            self.collectionView.reloadData()
        }
    }
}

extension HomeViewController: ReloadFromJobDetailViewControllerDelegate {
    func reloadJobApplications(_ viewController: JobDetailViewController, alertMessage: String?) {
        if alertMessage != nil {
            showAlert(title: "Error editing application.", message: "\(String(describing: alertMessage)).")
        } else {
            reloadCollectionView()
        }
    }
}

extension HomeViewController: ReloadFromAddNewJobViewControllerDelegate {
    func reloadJobApplications(_ viewController: AddNewJobViewController, alertMessage: String?) {
        if alertMessage != nil {
            showAlert(title: "Error adding new application.", message: "\(String(describing: alertMessage)).")
        } else {
            reloadCollectionView()
        }
    }
}
