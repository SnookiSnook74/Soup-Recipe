//
//  StorageDataManager.swift
//  Soup Recipe
//
//  Created by DonHalab on 07.04.2024.
//

import CoreData
import UIKit

final class StorageDataManager {
    
    var fetchedResultsController: NSFetchedResultsController<RecipeEntity>!
    
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
    
            let resultStepAndIgredients = stepsAndIngredients(recipe: recipe)
            
            recipeEntity.step = resultStepAndIgredients.step
            recipeEntity.ingredients = resultStepAndIgredients.ingredients

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
    
    func stepsAndIngredients(recipe: Recipe) -> (step: String,  ingredients: String) {
        var stepString = ""
        var ingredientsString = ""
        
        for (index, step) in recipe.steps.enumerated() {
            stepString += "Шаг \(index + 1): \(step.step)"
            stepString += "\n\n"
            
            for ingredient in step.ingredients {
                ingredientsString += "\(ingredient.name) - \(ingredient.quantity)\n"
            }
        }
        ingredientsString.removeLast()
        stepString.removeLast()
        
        return (stepString, ingredientsString)
    }
    
    /// Обновление рецепта (используем как ключ ingredients так как это поле неизменяемо)
    func updateRecipeInformation(recipe: WrapperModel,newName: String, newDescription: String, newStep: String) {
        let fetchRequest: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "ingredients == %@", recipe.ingredient!)
        
        do {
            let results = try context.fetch(fetchRequest)
            var recipeEntity: RecipeEntity
            if let existingRecipe = results.first {
                recipeEntity = existingRecipe
            } else {
                recipeEntity = RecipeEntity(context: context)
            }
            recipeEntity.name = newName
            recipeEntity.descriptionRecipe = newDescription
            recipeEntity.step = newStep
        
            saveContext()
        } catch {
            print("Ошибка при обновлении рецепта в описании: \(error)")
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
    
    /// Обработка одного конкретного рецепта
    func fetchRecipes(indexPath: IndexPath) -> WrapperModel {
        let result = fetchedResultsController?.object(at: indexPath)
        return WrapperModel(name: result?.name, image: result?.image,
                            description: result?.descriptionRecipe,
                            step: result?.step, ingredient: result?.ingredients)
    }
    
    /// Обертка для всех рецептов из базы
    func fetchAllRecipes() -> [WrapperModel] {
        guard let objects = fetchedResultsController?.fetchedObjects else { return [] }
        return objects.map { result in
            WrapperModel(name: result.name, image: result.image,
                         description: result.descriptionRecipe,
                         step: result.step, ingredient: result.ingredients)
        }
    }

}

