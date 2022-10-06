//
//  TextView.swift
//  JobApplicationTracker
//
//  Created by Steven Hill on 22/09/2022.
//

import UIKit

class TextView: UITextView {
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        configureTextView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(placeholderText: String) {
        self.init(frame: .zero)
        text = placeholderText
    }
    
    private func configureTextView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .tertiarySystemBackground
        layer.cornerRadius = 5
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray.cgColor
        textColor = .label
        tintColor = .lightGray
        textAlignment = .left
        font = UIFont.preferredFont(forTextStyle: .title2)
        autocorrectionType = .default
        returnKeyType = .default
    }
}
