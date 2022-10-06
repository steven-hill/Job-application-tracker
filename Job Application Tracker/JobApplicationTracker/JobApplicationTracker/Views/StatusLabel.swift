//
//  StatusLabel.swift
//  JobApplicationTracker
//
//  Created by Steven Hill on 02/10/2022.
//

import UIKit

class StatusLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        textColor = .label
        text = "Status:"
        backgroundColor = .systemGray6
        font = UIFont.preferredFont(forTextStyle: .title2)
        translatesAutoresizingMaskIntoConstraints = false
    }
}
