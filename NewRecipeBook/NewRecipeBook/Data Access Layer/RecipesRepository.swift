//
//  RecipesRepository.swift
//  Soup Recipe
//
//  Created by DonHalab on 09.04.2024.
//

import Foundation
import CoreData


class RecipesRepository {
    private let jsonParser: RecipeParser = JsonParser()
    private let context = StorageDataManager.shared.context

    /// Метод для загрузки данных в CoreData из RecipeModel
    func loadRecipesFromJsonAndSaveToCoreData() {
        Task {
            let recipes = jsonParser.parseRecipes()
            
            for recipe in recipes {
                let exists = await recipeExists(withURL: recipe.imageUrl)
                if exists {
                    await StorageDataManager.shared.updateOrCreateRecipe(from: recipe)
                }
            }
        }
    }

    ///  Проверка есть и рецепт в базе и установленно ли у него изображение
    private func recipeExists(withURL url: String) async -> Bool {
        let fetchRequest: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "imageUrl == %@", url)
        
        do {
            let result = try context.fetch(fetchRequest)
            if result.first?.image == nil {
                return true
            }
        } catch {
            print("Ошибка проверке рецепта: \(error)")
        }
    
        do {
            let count = try context.count(for: fetchRequest)
            return count < 0
        } catch {
            print("Ошибка при проверке наличия рецепта: \(error)")
            return false
        }
    }

    
}
