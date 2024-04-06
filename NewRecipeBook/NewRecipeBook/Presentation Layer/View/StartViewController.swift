//
//  StartViewController.swift
//  NewRecipeBook
//
//  Created by DonHalab on 15.12.2023.
//

import UIKit

class StartViewController: UIViewController {
    
    var jsonParser = JsonParser()
    var allRecipe: [Recipe]?
    
    var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Поиск рецептов"
        return searchBar
    }()
    
    var table: UITableView = {
        let table = UITableView()
        table.register(RecipeTableViewCell.self, forCellReuseIdentifier: "RecipeCell")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    func loadRecipes() {
        table.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allRecipe = jsonParser.parseRecipes()
        setupView()
        constraintSetup()
    }
    
    func setupView() {
        view.addSubview(table)
        table.dataSource = self
        table.delegate = self
        table.keyboardDismissMode = .onDrag
        navigationItem.titleView = searchBar
        view.backgroundColor = .white
    }
    
    @objc func updateUI() {
        loadRecipes()
    }
    
    func constraintSetup() {
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            table.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}


extension StartViewController: UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = DetailRecipeViewController()
        navigationController?.pushViewController(detail, animated: true)
    }
}

extension StartViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return allRecipe?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as? RecipeTableViewCell else {
            fatalError("Не удалось найти указанную TableViewCell")
        }
        
        if let recipe = allRecipe?[indexPath.row] {
            cell.recipeName.text = recipe.name
            
            Task {
                do {
                    let image = try await NetworkManager.shared.loadImage(url: recipe.image_url)
                    if let updateCell = tableView.cellForRow(at: indexPath) as? RecipeTableViewCell {
                        DispatchQueue.main.async {
                            updateCell.recipeImage.image = image
                        }
                    }
                } catch {
                    fatalError("Что-то пошло не так")
                }
            }
        }
        return cell
    }
}


//#Preview {
//    StartViewController()
//}
