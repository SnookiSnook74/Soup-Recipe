//
//  RecipeInfo.swift
//  NewRecipeBook
//
//  Created by DonHalab on 15.12.2023.
//

import Foundation

struct Recipe: Codable {
    var name: String
    var description: String
    var image_url: String
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
