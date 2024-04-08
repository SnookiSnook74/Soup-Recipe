//
//  RecipeViewModel.swift
//  Soup Recipe
//
//  Created by DonHalab on 06.04.2024.
//

import CoreData
import Foundation

class RecipeViewModel {
    
    private let jsonParser: RecipeParser = JsonParser()
    var fetchedResultsController: NSFetchedResultsController<RecipeEntity>!
    
    init() {
        setupFetchedResultsController()
        loadRecipesFromJsonAndSaveToCoreData()
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
    
    /// Метод для загрузки данных в CoreData из RecipeModel
    private func loadRecipesFromJsonAndSaveToCoreData() {
        Task {
            let dataExists = await checkDataExists()
            guard !dataExists else { return }
            
            let recipes = jsonParser.parseRecipes()
            
            for recipe in recipes {
                await StorageDataManager.shared.updateOrCreateRecipe(from: recipe)
            }
            do {
                try fetchedResultsController.performFetch()
            } catch let error as NSError {
                fatalError("Не удалось загрузить данные после обновления: \(error), \(error.userInfo)")
            }
        }
    }
    
    /// Вспомогательный метод для проверки, что наша база была загружена первый раз, это необходимо
    /// для того чтобы при каждом перезапуске не перезаписывать все данные из нашей изначальной модели
    private func checkDataExists() async -> Bool {
        let fetchRequest: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        do {
            let count = try StorageDataManager.shared.context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Ошибка при проверке наличия данных: \(error)")
            return false
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


