//
//  DetailRecipeViewController.swift
//  NewRecipeBook
//
//  Created by DonHalab on 19.12.2023.
//

import UIKit

class DetailRecipeViewController: UIViewController {
    
    var recipe: Recipe?

    var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    var imagesView: UIImageView = {
        let images = UIImageView()
        images.translatesAutoresizingMaskIntoConstraints = false
        images.contentMode = .scaleAspectFill
        images.clipsToBounds = true
        return images
    }()

    var descriptionLabel: UILabel = {
        var descript = UILabel()
        descript.translatesAutoresizingMaskIntoConstraints = false
        descript.font = .boldSystemFont(ofSize: 22)
        descript.text = "Описание"
        return descript
    }()

    var descriptionViewList: UILabel = {
        var descript = UILabel()
        descript.translatesAutoresizingMaskIntoConstraints = false
        descript.font = .systemFont(ofSize: 18)
        descript.numberOfLines = 0
        return descript
    }()

    var ingredientsViewLabel: UILabel = {
        let ingredientsView = UILabel()
        ingredientsView.translatesAutoresizingMaskIntoConstraints = false
        ingredientsView.font = .boldSystemFont(ofSize: 22)
        ingredientsView.text = "Ингредиенты"
        return ingredientsView
    }()

    var ingredientsListView: UILabel = {
        let ingredientsList = UILabel()
        ingredientsList.translatesAutoresizingMaskIntoConstraints = false
        ingredientsList.font = .systemFont(ofSize: 18)
        ingredientsList.numberOfLines = 0
        return ingredientsList
    }()

    var stepsViewLabel: UILabel = {
        let stepsView = UILabel()
        stepsView.translatesAutoresizingMaskIntoConstraints = false
        stepsView.font = .boldSystemFont(ofSize: 22)
        stepsView.text = "Пошаговый рецепт"
        return stepsView
    }()

    var stepsViewList: UILabel = {
        let stepsView = UILabel()
        stepsView.translatesAutoresizingMaskIntoConstraints = false
        stepsView.numberOfLines = 0
        stepsView.font = .systemFont(ofSize: 18)
        return stepsView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Описание"
        setupView()
        addView()
        setupConstraint()
        setupNavigationBar()
        configureUI()

        view.backgroundColor = .white
    }
    
    private func configureUI() {
        guard let recipe = recipe else { return }
        
        title = recipe.name
        Task {
            imagesView.image = try await NetworkManager.shared.loadImage(url: recipe.image_url)
        }
        descriptionViewList.text = recipe.description
        ingredientsListView.text = recipe.steps.first?.ingredients.map {"\($0.name) : \($0.quantity)"}.joined(separator: "\n")
        stepsViewList.text = recipe.steps.map { "Шаг \($0.number): \($0.step)" }.joined(separator: "\n\n")
    }

    @objc func updateUI() {

    }

    private func setupView() {
       
    }

    @objc private func editRecipe() {
        let editRecipe = EditRecipeViewController()
        navigationController?.pushViewController(editRecipe, animated: true)
    }
}

extension DetailRecipeViewController {
    private func setupNavigationBar() {
        let buttonEdit = UIBarButtonItem(title: "Редактировать", style: .plain, target: self, action: #selector(editRecipe))
        navigationItem.rightBarButtonItem = buttonEdit
    }
}

extension DetailRecipeViewController {
    func addView() {
        view.addSubview(scrollView)
        scrollView.addSubview(imagesView)
        scrollView.addSubview(descriptionLabel)
        scrollView.addSubview(descriptionViewList)
        scrollView.addSubview(ingredientsViewLabel)
        scrollView.addSubview(ingredientsListView)
        scrollView.addSubview(stepsViewLabel)
        scrollView.addSubview(stepsViewList)
    }
}

extension DetailRecipeViewController {
    func setupConstraint() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            imagesView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            imagesView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imagesView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imagesView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            imagesView.heightAnchor.constraint(equalToConstant: 350),

            descriptionLabel.topAnchor.constraint(equalTo: imagesView.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            descriptionViewList.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            descriptionViewList.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionViewList.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            ingredientsViewLabel.topAnchor.constraint(equalTo: descriptionViewList.bottomAnchor, constant: 10),
            ingredientsViewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            ingredientsViewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            ingredientsListView.topAnchor.constraint(equalTo: ingredientsViewLabel.bottomAnchor, constant: 10),
            ingredientsListView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            ingredientsListView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            stepsViewLabel.topAnchor.constraint(equalTo: ingredientsListView.bottomAnchor, constant: 10),
            stepsViewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stepsViewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            stepsViewList.topAnchor.constraint(equalTo: stepsViewLabel.bottomAnchor, constant: 10),
            stepsViewList.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stepsViewList.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stepsViewList.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),

        ])
    }
}
