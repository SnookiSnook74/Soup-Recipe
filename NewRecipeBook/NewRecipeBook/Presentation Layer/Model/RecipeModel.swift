//
//  RecipeInfo.swift
//  NewRecipeBook
//
//  Created by DonHalab on 15.12.2023.
//

import Foundation
import UIKit

/// Модель рецепта
struct Recipe: Codable {
    var name: String
    var description: String
    var imageUrl: String
    var steps: [Step]
}

struct Step: Codable {
    var ingredients: [Ingredient]
    var number: Int
    var step: String
}

struct Ingredient: Codable {
    var id: Int
    var name: String
    var quantity: String
}


struct WrapperModel {
    var name: String?
    var image: Data?
}
