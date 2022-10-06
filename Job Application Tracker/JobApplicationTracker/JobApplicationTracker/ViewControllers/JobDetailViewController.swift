//
//  JobDetailViewController.swift
//  JobApplicationTracker
//
//  Created by Steven Hill on 22/09/2022.
//

import UIKit
import CoreData

protocol JobDetailViewControllerDelegate: AnyObject {
    func editJob(_ viewController: JobDetailViewController, editedJob: Job, index: Int)
    func deleteJob(_ viewController: JobDetailViewController, index: Int)
}

class JobDetailViewController: UIViewController {
    
    var index: Int
    
    init(index: Int) {
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var context: NSManagedObjectContext {
        return CoreDataManager.manager.persistentContainer.viewContext
    }
    
    let companyNameTextfield = Textfield(placeholder: " Company name")
    let positionTextfield = Textfield(placeholder: " Position")
    let locationTextfield = Textfield(placeholder: " Location")
    let statusLabel = StatusLabel()
    let statusPopUpButton = PopUpButton()
    let notesTextView = TextView(placeholderText: "Notes")
    let deleteButton = DeleteButton()

    weak var delegate: JobDetailViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        view.addSubview(companyNameTextfield)
        view.addSubview(positionTextfield)
        view.addSubview(locationTextfield)
        view.addSubview(statusLabel)
        view.addSubview(statusPopUpButton)
        view.addSubview(notesTextView)
        view.addSubview(deleteButton)

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        
        companyNameTextfield.delegate = self
        positionTextfield.delegate = self
        locationTextfield.delegate = self
        notesTextView.delegate = self
        
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        
        layoutViews()

        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }

    @objc func cancelTapped() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func doneTapped()  {
        let editedJob = Job(context: self.context)
        editedJob.company = companyNameTextfield.text!
        editedJob.position = positionTextfield.text!
        editedJob.location = locationTextfield.text!
        editedJob.status = statusPopUpButton.currentTitle!
        editedJob.notes = notesTextView.text!
        let editedJobIndex = index

        delegate?.editJob(self, editedJob: editedJob, index: editedJobIndex)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func deleteButtonTapped() {
        let alert = UIAlertController(title: "Are you sure?", message: "", preferredStyle: .alert)
        
        let delete = UIAlertAction(title: "Delete", style: .default) { (delete) in
            self.delegate?.deleteJob(self, index: self.index)
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(delete)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
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
            notesTextView.heightAnchor.constraint(equalToConstant: 150),
            
            deleteButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            deleteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            deleteButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

extension JobDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension JobDetailViewController: UITextViewDelegate {
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
