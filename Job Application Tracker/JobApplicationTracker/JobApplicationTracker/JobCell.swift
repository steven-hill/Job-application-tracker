//
//  JobCell.swift
//  JobApplicationTracker
//
//  Created by Steven Hill on 26/08/2022.
//

import UIKit

class JobCell: UICollectionViewCell {
    
    @IBOutlet weak var companyLabel: UILabel!
    
    @IBOutlet weak var positionLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    func setupCell(with job: Job) {
        companyLabel.text = job.company
        positionLabel.text = job.position
        locationLabel.text = job.location
        statusLabel.text = job.status
    }
}
