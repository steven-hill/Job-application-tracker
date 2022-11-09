//
//  AddNewJobViewController.swift
//  JobApplicationTracker
//
//  Created by Steven Hill on 01/10/2022.
//

import UIKit
import CoreData

protocol AddNewJobViewControllerDelegate {
    func addJob(newJob: Job)
    var alertMessage: String? { get set }
}

protocol ReloadFromAddNewJobViewControllerDelegate {
    func reloadJobApplications(_ viewController: AddNewJobViewController, alertMessage: String?)
}

class AddNewJobViewController: UIViewController {
    
    let companyNameTextfield = Textfield(placeholder: "Company name")
    let positionTextfield = Textfield(placeholder: "Position")
    let locationTextfield = Textfield(placeholder: "Location")
    let statusLabel = StatusLabel()
    let statusPopUpButton = PopUpButton()
    let notesTextView = TextView(placeholderText: "Notes")
    
    var context: NSManagedObjectContext {
        return CoreDataManager.manager.persistentContainer.viewContext
    }
    
    var delegate: AddNewJobViewControllerDelegate?
    var reloadDelegate: ReloadFromAddNewJobViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        view.addSubview(companyNameTextfield)
        view.addSubview(positionTextfield)
        view.addSubview(locationTextfield)
        view.addSubview(statusPopUpButton)
        view.addSubview(notesTextView)
        view.addSubview(statusLabel)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        
        companyNameTextfield.delegate = self
        positionTextfield.delegate = self
        locationTextfield.delegate = self
        notesTextView.delegate = self
        
        layoutViews()
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @objc func cancelTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func doneTapped()  {
        let newJob = Job(context: self.context)
        newJob.company = companyNameTextfield.text!
        newJob.position = positionTextfield.text!
        newJob.location = locationTextfield.text!
        newJob.status = statusPopUpButton.currentTitle!
        newJob.notes = notesTextView.text!
        
        delegate?.addJob(newJob: newJob)
        let message = delegate?.alertMessage
        reloadDelegate?.reloadJobApplications(self, alertMessage: message)
        self.dismiss(animated: true, completion: nil)
    }
    
    func layoutViews() {
        NSLayoutConstraint.activate([
            companyNameTextfield.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            companyNameTextfield.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            companyNameTextfield.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            companyNameTextfield.heightAnchor.constraint(equalToConstant: 50),
            
            positionTextfield.topAnchor.constraint(equalTo: companyNameTextfield.bottomAnchor, constant: 20),
            positionTextfield.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            positionTextfield.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            positionTextfield.heightAnchor.constraint(equalToConstant: 50),
            
            locationTextfield.topAnchor.constraint(equalTo: positionTextfield.bottomAnchor, constant: 20),
            locationTextfield.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            locationTextfield.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            locationTextfield.heightAnchor.constraint(equalToConstant: 50),
            
            statusLabel.topAnchor.constraint(equalTo: locationTextfield.bottomAnchor, constant: 20),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statusLabel.widthAnchor.constraint(equalToConstant: 80),
            statusLabel.heightAnchor.constraint(equalToConstant: 50),
            
            statusPopUpButton.topAnchor.constraint(equalTo: locationTextfield.bottomAnchor, constant: 20),
            statusPopUpButton.leadingAnchor.constraint(equalTo: statusLabel.trailingAnchor, constant: 20),
            statusPopUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            statusPopUpButton.heightAnchor.constraint(equalToConstant: 50),
            
            notesTextView.topAnchor.constraint(equalTo: statusPopUpButton.bottomAnchor, constant: 20),
            notesTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            notesTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            notesTextView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
}

extension AddNewJobViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension AddNewJobViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Notes" {
            textView.text = ""
            textView.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Notes"
            textView.textColor = UIColor.lightGray
        }
    }
}
