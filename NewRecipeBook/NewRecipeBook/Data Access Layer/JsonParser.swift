//
//  JsonParser.swift
//  NewRecipeBook
//
//  Created by DonHalab on 15.12.2023.
//

import Foundation

final class JsonParser: RecipeParser {
    func parseRecipes() -> [Recipe] {
        guard let url = Bundle.main.url(forResource: "recipe", withExtension: "json"),
              let data = try? Data(contentsOf: url)
        else {
            print("JSON file not found")
            return []
        }
        let decoder = JSONDecoder()
        do {
            let recipes = try decoder.decode([Recipe].self, from: data)
            return recipes
        } catch {
            print("Error decoding JSON: \(error)")
            return []
        }
    }
}
