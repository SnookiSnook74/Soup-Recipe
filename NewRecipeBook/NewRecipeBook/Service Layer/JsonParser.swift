//
//  JsonParser.swift
//  NewRecipeBook
//
//  Created by DonHalab on 15.12.2023.
//

import Foundation

/// Класс отвечающий за парсинг данных из файлов формата JSON
///  - Returns: Заполненная модель данных типа Recipe
final class JsonParser: RecipeParser {
    func parseRecipes() -> [Recipe] {
        guard let url = Bundle.main.url(forResource: "recipe", withExtension: "json"),
              let data = try? Data(contentsOf: url)
        else {
            print("JSON не найден")
            return []
        }
        let decoder = JSONDecoder()
        do {
            let recipes = try decoder.decode([Recipe].self, from: data)
            return recipes
        } catch {
            print("Ошибка декодирования JSON: \(error)")
            return []
        }
    }
}
