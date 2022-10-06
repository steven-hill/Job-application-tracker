//
//  PopUpButton.swift
//  JobApplicationTracker
//
//  Created by Steven Hill on 24/09/2022.
//

import UIKit

class PopUpButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var menuItems: [UIAction] {
        return [
            UIAction(title: "Submitted resume", handler: { (_) in }),
            UIAction(title: "Take home project", handler: { (_) in }),
            UIAction(title: "Interview", handler: { (_) in }),
            UIAction(title: "Rejection email", handler: { (_) in }),
            UIAction(title: "Accepted offer", handler: { (_) in }),
            UIAction(title: "Rejected offer", handler: { (_) in }),
        ]
    }
    
    var statusMenu: UIMenu {
        return UIMenu(children: menuItems)
    }
    
    func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 5
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray.cgColor
        backgroundColor = .black
        menu = statusMenu
        showsMenuAsPrimaryAction = true
        changesSelectionAsPrimaryAction = true
    }
}
