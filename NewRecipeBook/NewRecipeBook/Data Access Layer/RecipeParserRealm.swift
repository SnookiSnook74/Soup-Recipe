//
//  RecipeParserRealm.swift
//  NewRecipeBook
//
//  Created by DonHalab on 18.12.2023.
//

import Foundation

class RecipeParserRealm {
    var parser: RecipeParserForRealm

    struct dataBaseParse {
        var name: String
        var description: String
        var imageUrl: String
        var ingredients: String
        var steps: String
    }

    init(parser: RecipeParserForRealm = JsonParser()) {
        self.parser = parser
    }

    func parserInfo() -> [dataBaseParse] {
        let recipes = parser.parseRecipes()
        return recipes.map { recipe in
            let ingredients = recipe.steps.flatMap { $0.ingredients }
                .map { "\($0.name): \($0.quantity)" }
                .joined(separator: ", ")
            let steps = recipe.steps.map { "Шаг \($0.number): \($0.step)" }
                .joined(separator: "\n")

            return dataBaseParse(name: recipe.name,
                                 description: recipe.description,
                                 imageUrl: recipe.image_url,
                                 ingredients: ingredients,
                                 steps: steps)
        }
    }
}
