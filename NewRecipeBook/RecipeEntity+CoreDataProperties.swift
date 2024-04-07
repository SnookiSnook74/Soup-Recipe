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
    @NSManaged public var steps: NSSet?

}

// MARK: Generated accessors for steps
extension RecipeEntity {

    @objc(addStepsObject:)
    @NSManaged public func addToSteps(_ value: StepEntity)

    @objc(removeStepsObject:)
    @NSManaged public func removeFromSteps(_ value: StepEntity)

    @objc(addSteps:)
    @NSManaged public func addToSteps(_ values: NSSet)

    @objc(removeSteps:)
    @NSManaged public func removeFromSteps(_ values: NSSet)

}

extension RecipeEntity : Identifiable {

}
