//
//  DetailRecipeViewController.swift
//  NewRecipeBook
//
//  Created by DonHalab on 19.12.2023.
//

import UIKit

class DetailRecipeViewController: UIViewController {
    
    var recipe: WrapperModel?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.register(DetailImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCollectionViewCell")
        collectionView.register(DetailTitleCollectionViewCell.self, forCellWithReuseIdentifier: "TitleCollectionViewCell")
        collectionView.register(DetailTextCollectionViewCell.self, forCellWithReuseIdentifier: "TextCollectionViewCell")
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        collectionView.collectionViewLayout = createLayout()
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        addConstraint()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Редактировать", 
                                                            style: .plain, target: self,
                                                            action: #selector(editRecipe))
    }
    
    func addConstraint() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    @objc func editRecipe() {
        let editRecipe = EditRecipeViewController()
        editRecipe.recipe = self.recipe
        navigationController?.pushViewController(editRecipe, animated: true)
    }
}

extension DetailRecipeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { return 0 }
        return section.itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let section = Section(rawValue: indexPath.section) else { fatalError("Ошибка в коллекции") }
        
        var identificator = section.cellIdentifier(for: indexPath)
        
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: identificator, for: indexPath)
        
        switch section {
        case .image:
            if let cell = cell as? DetailImageCollectionViewCell, let imageData = recipe?.image {
                cell.imageView.image = UIImage(data: imageData)
            }
        case .description:
            if let cell = cell as? DetailTitleCollectionViewCell {
                cell.titleLabel.text = "Описание"
            } else if let cell = cell as? DetailTextCollectionViewCell {
                cell.textLabel.text = recipe?.description
            }
        case .ingredients:
            if let cell = cell as? DetailTitleCollectionViewCell {
                cell.titleLabel.text = "Ингредиенты"
            } else if let cell = cell as? DetailTextCollectionViewCell {
                cell.textLabel.text = recipe?.ingredient
            }
        case .steps:
            if let cell = cell as? DetailTitleCollectionViewCell {
                cell.titleLabel.text = "Пошаговый рецепт"
            } else if let cell = cell as? DetailTextCollectionViewCell {
                cell.textLabel.text = recipe?.step
            }
        }
        return cell
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(50))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}


