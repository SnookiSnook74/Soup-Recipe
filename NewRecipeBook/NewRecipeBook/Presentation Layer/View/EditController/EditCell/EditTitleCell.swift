//
//  EditTitleCell.swift
//  Soup Recipe
//
//  Created by DonHalab on 11.04.2024.
//

import UIKit

class EditTitleCell: UICollectionViewCell {
    
    var title: UILabel = {
        var title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font =  UIFont.boldSystemFont(ofSize: 22)
        return title
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview()
        addConstraint()
    }
    
    func configure(newTitle: String) {
        title.text = newTitle
    }

    func addSubview() {
        addSubview(title)
    }
    
    func addConstraint() {
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            title.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
