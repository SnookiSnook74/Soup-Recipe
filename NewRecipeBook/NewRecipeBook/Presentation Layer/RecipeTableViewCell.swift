//
//  RecipeTableViewCell.swift
//  NewRecipeBook
//
//  Created by DonHalab on 19.12.2023.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {
    let imagesView: UIImageView = {
        var imagesView = UIImageView()
        imagesView.contentMode = .scaleAspectFill
        imagesView.layer.cornerRadius = 35
        imagesView.layer.masksToBounds = true
        imagesView.translatesAutoresizingMaskIntoConstraints = false
        return imagesView
    }()

    let text: UILabel = {
        var text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(imagesView)
        contentView.addSubview(text)
        setupConstraints()
    }

    func configure(with recipe: RealmRecipe) {
        text.text = recipe.name
        if let imageData = recipe.imageData, let image = UIImage(data: imageData) {
            imagesView.image = image
        } else {
            imagesView.image = UIImage(named: "placeholder")
        }
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            imagesView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            imagesView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imagesView.widthAnchor.constraint(equalToConstant: 70),
            imagesView.heightAnchor.constraint(equalToConstant: 70),

            text.leadingAnchor.constraint(equalTo: imagesView.trailingAnchor, constant: 10),
            text.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            text.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
