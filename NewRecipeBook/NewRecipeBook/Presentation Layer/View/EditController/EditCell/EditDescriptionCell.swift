//
//  EditDescriptionCell.swift
//  Soup Recipe
//
//  Created by DonHalab on 11.04.2024.
//

import UIKit

protocol EditDescriptionCellDelegate {
    func textDidChange(in cell: EditDescriptionCell)
}

class EditDescriptionCell: UICollectionViewCell, UITextViewDelegate {
    
    var delegate: EditDescriptionCellDelegate?
    
    var textDescriptiont: UITextView = {
        var description = UITextView()
        description.translatesAutoresizingMaskIntoConstraints = false
        description.font = UIFont.systemFont(ofSize: 18)
        description.isScrollEnabled = false
        description.backgroundColor = .quaternarySystemFill
        return description
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview()
        addConstraint()
        textDescriptiont.delegate = self
    }
    
    func textViewDidChange(_ textView: UITextView) {
        delegate?.textDidChange(in: self)
    }
    
    func configure(text: String) {
        textDescriptiont.text = text
    }
    
    func addConstraint() {
        NSLayoutConstraint.activate([
            textDescriptiont.topAnchor.constraint(equalTo: topAnchor),
            textDescriptiont.bottomAnchor.constraint(equalTo: bottomAnchor),
            textDescriptiont.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            textDescriptiont.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
    func addSubview() {
        addSubview(textDescriptiont)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
