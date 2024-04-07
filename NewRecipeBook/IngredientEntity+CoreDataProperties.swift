//
//  IngredientEntity+CoreDataProperties.swift
//  Soup Recipe
//
//  Created by DonHalab on 07.04.2024.
//
//

import Foundation
import CoreData

@objc(IngredientEntity)
public class IngredientEntity: NSManagedObject {

}

extension IngredientEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<IngredientEntity> {
        return NSFetchRequest<IngredientEntity>(entityName: "IngredientEntity")
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var quality: String?
    @NSManaged public var steps: StepEntity?

}

extension IngredientEntity : Identifiable {

}
