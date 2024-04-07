//
//  StepEntity+CoreDataProperties.swift
//  Soup Recipe
//
//  Created by DonHalab on 07.04.2024.
//
//

import Foundation
import CoreData

@objc(StepEntity)
public class StepEntity: NSManagedObject {

}

extension StepEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StepEntity> {
        return NSFetchRequest<StepEntity>(entityName: "StepEntity")
    }

    @NSManaged public var number: Int16
    @NSManaged public var step: String?
    @NSManaged public var ingredients: NSSet?
    @NSManaged public var recipe: RecipeEntity?

}

// MARK: Generated accessors for ingredients
extension StepEntity {

    @objc(addIngredientsObject:)
    @NSManaged public func addToIngredients(_ value: IngredientEntity)

    @objc(removeIngredientsObject:)
    @NSManaged public func removeFromIngredients(_ value: IngredientEntity)

    @objc(addIngredients:)
    @NSManaged public func addToIngredients(_ values: NSSet)

    @objc(removeIngredients:)
    @NSManaged public func removeFromIngredients(_ values: NSSet)

}

extension StepEntity : Identifiable {

}
