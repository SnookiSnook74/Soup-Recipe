//
//  StartViewController.swift
//  NewRecipeBook
//
//  Created by DonHalab on 15.12.2023.
//

import UIKit
import CoreData

class StartViewController: UIViewController {
    
    let viewModel = RecipeViewModel()
    
    var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Поиск рецептов"
        searchBar.backgroundColor = .systemBackground
        return searchBar
    }()
    
    var table: UITableView = {
        let table = UITableView()
        table.register(RecipeTableViewCell.self, forCellReuseIdentifier: "RecipeCell")
        table.backgroundColor = .systemBackground
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        constraintSetup()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTable), name: .reloadTable, object: nil)
    }
    
    /// Начальные настройки нашей View
    func setupView() {
        view.addSubview(table)
        searchBar.delegate = self
        table.dataSource = self
        table.delegate = self
        viewModel.fetchedResultsController.delegate = self
        table.keyboardDismissMode = .onDrag
        navigationItem.titleView = searchBar
        view.backgroundColor = .white
    }
    
    func constraintSetup() {
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: view.topAnchor),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            table.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    @objc func reloadTable() {
        table.reloadData()
    }
}

extension StartViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.updateSearchResults(for: searchText)
        table.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        viewModel.updateSearchResults(for: "")
    }
}

extension StartViewController: UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailRecipeViewController()
        let selectedRecipe = StorageDataManager.shared.fetchRecipes(indexPath: indexPath)
        detailVC.recipe = selectedRecipe
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension StartViewController: UITableViewDataSource {
    
    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = viewModel.fetchedResultsController.sections else { return 0 }
        return sections[section].numberOfObjects
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as? RecipeTableViewCell else {
            fatalError("Не удалось найти указанную TableViewCell")
        }
        
        let viewModel = StorageDataManager.shared.fetchRecipes(indexPath: indexPath)
        
        cell.recipeName.text = viewModel.name
        if let imageData = viewModel.image {
            cell.recipeImage.image = UIImage(data: imageData)
        }
        return cell
    }
}

extension StartViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        table.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        table.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            table.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            table.deleteRows(at: [indexPath!], with: .left)
        case .update:
            table.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            table.moveRow(at: indexPath!, to: newIndexPath!)
        @unknown default:
            fatalError("Ошибка в Controller")
        }
    }
}

