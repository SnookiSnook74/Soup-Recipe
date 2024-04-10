//
//  DetailRecipeTextCell.swift
//  Soup Recipe
//
//  Created by DonHalab on 09.04.2024.
//

import UIKit

class DetailTextCollectionViewCell: UICollectionViewCell {
    
    let textLabel: UILabel = {
        var textLabel = UILabel()
        textLabel.font = UIFont.systemFont(ofSize: 18)
        textLabel.numberOfLines = 0
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        addConstraint()
    }
    
    func addSubviews() {
        contentView.addSubview(textLabel)
    }
    
    func addConstraint() {
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            textLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

