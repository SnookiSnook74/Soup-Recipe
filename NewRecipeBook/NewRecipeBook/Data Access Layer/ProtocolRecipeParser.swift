//
//  ProtocolRecipeParserForRealm.swift
//  NewRecipeBook
//
//  Created by DonHalab on 18.12.2023.
//

import Foundation

/// Протокол котому должны соответстовать любые парсеры
protocol RecipeParser {
    func parseRecipes() -> [Recipe]
}
