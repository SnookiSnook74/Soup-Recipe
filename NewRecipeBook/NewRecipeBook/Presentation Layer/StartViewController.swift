//
//  StartViewController.swift
//  NewRecipeBook
//
//  Created by DonHalab on 15.12.2023.
//

import RealmSwift
import UIKit

class StartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var dataManager = RealmDatabaseManager()
    var recipes: Results<RealmRecipe>?
    
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
        recipes = dataManager.loadRecipes()
        table.reloadData()
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return recipes?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as? RecipeTableViewCell else {
            fatalError("The dequeued cell is not an instance of RecipeTableViewCell.")
        }

        if let recipe = recipes?[indexPath.row] {
            cell.configure(with: recipe)
        }

        return cell
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        80
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = DetailRecipeViewController()
        detail.recipe = recipes?[indexPath.row]
        navigationController?.pushViewController(detail, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: .recipeUpdated, object: nil)
        setupView()
        constraintSetup()
        dataManager.saveRecipesFromParser()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.loadRecipes()
        }
    }

    override func viewDidAppear(_: Bool) {
            self.loadRecipes()
    }

    func setupView() {
        view.addSubview(table)
        table.dataSource = self
        table.delegate = self
        searchBar.delegate = self
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

extension StartViewController: UISearchBarDelegate {
    
    func filterRecipes(for searchText: String) {
            recipes = dataManager.filterRecipes(for: searchText)
            table.reloadData()
        }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchText.isEmpty {
                loadRecipes()
            } else {
                filterRecipes(for: searchText)
            }
        }
}
