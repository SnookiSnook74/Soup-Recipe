//
//  ProtocolRecipeParserForRealm.swift
//  NewRecipeBook
//
//  Created by DonHalab on 18.12.2023.
//

import Foundation

protocol RecipeParser {
    func parseRecipes() -> [Recipe]
}
