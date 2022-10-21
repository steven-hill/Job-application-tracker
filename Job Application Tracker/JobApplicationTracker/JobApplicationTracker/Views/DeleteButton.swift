//
//  DeleteButton.swift
//  JobApplicationTracker
//
//  Created by Steven Hill on 02/10/2022.
//

import UIKit

class DeleteButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 5
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemRed.cgColor
        configuration = .tinted()
        configuration?.baseBackgroundColor = .tertiarySystemBackground
        configuration?.baseForegroundColor = .systemRed
        configuration?.title = "Delete"
        configuration?.image = UIImage(systemName: "trash")
        configuration?.imagePadding = 6
        translatesAutoresizingMaskIntoConstraints = false
    }
}
