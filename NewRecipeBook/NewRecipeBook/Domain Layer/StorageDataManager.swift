//
//  StorageDataManager.swift
//  Soup Recipe
//
//  Created by DonHalab on 07.04.2024.
//

import CoreData
import UIKit


final class StorageDataManager {
    
    var fetchedResultsController: NSFetchedResultsController<RecipeEntity>?
    
    static let shared = StorageDataManager()
    var persistentContainer: NSPersistentContainer!
    
    private init() {}
    
    var context: NSManagedObjectContext {
        guard let context = persistentContainer?.viewContext else {
            fatalError("Persistent container не был установлен.")
        }
        return context
    }
    
    /// Метод для сохранения контекста
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Не удалось сохранить изменения: \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    /// Добавление или обновление рецепта
    func updateOrCreateRecipe(from recipe: Recipe) async {
        let fetchRequest: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "imageUrl == %@", recipe.imageUrl)
        var stepString = ""
        var ingredientsString = ""
        
        do {
            let results = try context.fetch(fetchRequest)
            let recipeEntity: RecipeEntity
            
            if let existingRecipe = results.first {
                recipeEntity = existingRecipe
            } else {
                recipeEntity = RecipeEntity(context: context)
            }
            
            recipeEntity.name = recipe.name
            recipeEntity.descriptionRecipe = recipe.description
            recipeEntity.imageUrl = recipe.imageUrl
    
            
            for (index, step) in recipe.steps.enumerated() {
                stepString += "Шаг \(index + 1): \(step.step)"
                stepString += "\n\n"
                
                for ingredient in step.ingredients {
                    ingredientsString += "\(ingredient.name) - \(ingredient.quantity)\n"
                }
            }
        
            recipeEntity.step = stepString
            recipeEntity.ingredients = ingredientsString

            if recipeEntity.image == nil {
                let image = try await NetworkManager.shared.loadImage(url: recipe.imageUrl)
                if let imageData = image.jpegData(compressionQuality: 1.0) {
                    recipeEntity.image = imageData
                }
            }
            
            saveContext()
        } catch {
            print("Ошибка при обновлении рецепта: \(error)")
        }
    }

    /// Получение всех рецептов
    func fetchRecipes() async -> [RecipeEntity] {
        let fetchRequest: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        do {
            return try await context.perform {
                try self.context.fetch(fetchRequest)
            }
        } catch let error as NSError {
            print("Не удалось загрузить данные из CoreData. \(error), \(error.userInfo)")
            return []
        }
    }
    
    func fetchRecipes(indexPath: IndexPath) -> TestModel {
        let result = fetchedResultsController?.object(at: indexPath)
        return TestModel(name: result?.name, image: result?.image)
    }
    
    
    
    
//    func fetchRecipesTest(indexPath: IndexPath) -> TestModel {
//        let fetchRequest: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
//        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: StorageDataManager.shared.context, sectionNameKeyPath: nil, cacheName: nil)
//        let result = fetchedResultsController.object(at: indexPath)
//    
//        return TestModel(name: result.name, image: result.image)
//    }
}


