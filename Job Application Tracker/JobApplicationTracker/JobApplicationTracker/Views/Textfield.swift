//
//  Textfield.swift
//  JobApplicationTracker
//
//  Created by Steven Hill on 23/09/2022.
//

import UIKit

class Textfield: UITextField {
    
    var textPadding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(placeholder: String) {
        self.init(frame: .zero)
        self.placeholder = placeholder
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 5
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray.cgColor
        textColor = .label
        tintColor = .lightGray
        textAlignment = .left
        font = UIFont.preferredFont(forTextStyle: .title2)
        backgroundColor = .tertiarySystemBackground
        autocorrectionType = .default
        returnKeyType = .default
        clearButtonMode = .whileEditing
    }
}
