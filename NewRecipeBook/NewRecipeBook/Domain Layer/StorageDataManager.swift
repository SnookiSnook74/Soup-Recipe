//
//  StorageDataManager.swift
//  Soup Recipe
//
//  Created by DonHalab on 07.04.2024.
//

import Foundation
import CoreData
import UIKit


final class StorageDataManager {
    
    static let shared = StorageDataManager()
    
    private init() {}
    
    /// Ссылка на контекст Managed Object Context
     var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    /// Ссылка на Persistent Container
    var persistentContainer: NSPersistentContainer {
        var container: NSPersistentContainer?
        DispatchQueue.main.sync {
            container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
        }
        return container!
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
    
    
    // Добавление или обновление рецепта
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
                recipeEntity.imageUrl = recipe.imageUrl
                
                let image = try await NetworkManager.shared.loadImage(url: recipe.imageUrl)
                if let imageData = image.jpegData(compressionQuality: 1.0) {
                    recipeEntity.image = imageData
                }
            }
            
            recipeEntity.name = recipe.name
            recipeEntity.descriptionRecipe = recipe.description
            // Обновите связанные шаги и ингредиенты
            
            saveContext()
        } catch {
            print("Ошибка при обновлении рецепта: \(error)")
        }
    }


}
