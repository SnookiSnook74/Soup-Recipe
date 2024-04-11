//
//  EditImageCell.swift
//  Soup Recipe
//
//  Created by DonHalab on 11.04.2024.
//

import UIKit



class EditImageCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview()
        addConstraint()
    }
    
    func addConstraint() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalToConstant: 350)
        ])
    }
    
    func configure(imageData: Data) {
        imageView.image = UIImage(data: imageData)
    }
    
    func addSubview() {
        addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
