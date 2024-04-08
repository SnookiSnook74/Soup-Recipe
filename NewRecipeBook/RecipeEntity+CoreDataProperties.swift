//
//  RecipeEntity+CoreDataProperties.swift
//  Soup Recipe
//
//  Created by DonHalab on 07.04.2024.
//
//

import Foundation
import CoreData

@objc(RecipeEntity)
public class RecipeEntity: NSManagedObject {

}

extension RecipeEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecipeEntity> {
        return NSFetchRequest<RecipeEntity>(entityName: "RecipeEntity")
    }

    @NSManaged public var descriptionRecipe: String?
    @NSManaged public var image: Data?
    @NSManaged public var imageUrl: String?
    @NSManaged public var name: String?
    @NSManaged public var step: String?
    @NSManaged public var ingredients: String?

}

extension RecipeEntity : Identifiable {

}
