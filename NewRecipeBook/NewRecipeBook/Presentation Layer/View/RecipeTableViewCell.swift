//
//  RecipeTableViewCell.swift
//  NewRecipeBook
//
//  Created by DonHalab on 19.12.2023.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {
    
    var currentImageUrl: String?
    
    let recipeImage: UIImageView = {
        var imagesView = UIImageView()
        imagesView.contentMode = .scaleAspectFill
        imagesView.layer.cornerRadius = 35
        imagesView.layer.masksToBounds = true
        imagesView.translatesAutoresizingMaskIntoConstraints = false
        return imagesView
    }()

    let recipeName: UILabel = {
        var text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(recipeImage)
        contentView.addSubview(recipeName)
        setupConstraints()
    }


    func setupConstraints() {
        NSLayoutConstraint.activate([
            recipeImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            recipeImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            recipeImage.widthAnchor.constraint(equalToConstant: 70),
            recipeImage.heightAnchor.constraint(equalToConstant: 70),

            recipeName.leadingAnchor.constraint(equalTo: recipeImage.trailingAnchor, constant: 10),
            recipeName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            recipeName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
