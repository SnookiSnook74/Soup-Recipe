//
//  RecipeViewModel.swift
//  Soup Recipe
//
//  Created by DonHalab on 06.04.2024.
//

import Foundation


class RecipeViewModel {
    
    let jsonParser = JsonParser()
    var allRecipe: [Recipe] = []
    
    init() {
        allRecipe = jsonParser.parseRecipes()
        Task {
            await downloadRecipeInCoreDate()
        }
    }
    
    
    func downloadRecipeInCoreDate() async {
        for recipe in allRecipe {
            await StorageDataManager.shared.updateOrCreateRecipe(from: recipe)
        }
    }
    
    
}
