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
    }
    
    
    
}
