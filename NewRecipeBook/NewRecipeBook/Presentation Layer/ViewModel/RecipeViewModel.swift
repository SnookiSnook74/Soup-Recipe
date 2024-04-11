//
//  RecipeViewModel.swift
//  Soup Recipe
//
//  Created by DonHalab on 06.04.2024.
//

import CoreData
import Foundation


class RecipeViewModel {
    
    private var repository = RecipesRepository()
    
    var fetchedResultsController: NSFetchedResultsController<RecipeEntity>!
    
    init() {
        setupFetchedResultsController()
        repository.loadRecipesFromJsonAndSaveToCoreData()
        StorageDataManager.shared.fetchedResultsController = fetchedResultsController
    }

    /// Метод для настройки  NSFetchedResultsController
    private func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: StorageDataManager.shared.context,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            fatalError("Не удалось загрузить данные: \(error), \(error.userInfo)")
        }
    }
    
    /// Метод для обновления данных каждый раз когда в строке поиска вводиться информация
    func updateSearchResults(for searchText: String) {
        if searchText.isEmpty {
            fetchedResultsController.fetchRequest.predicate = nil
        } else {
            fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchText)
        }
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Ошибка фильтрации: \(error), \(error.userInfo)")
        }
    }
    
}


