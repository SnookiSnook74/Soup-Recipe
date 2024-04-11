//
//  EditRecipeSection.swift
//  Soup Recipe
//
//  Created by DonHalab on 11.04.2024.
//

import Foundation

enum EditRecipeSection: Int, CaseIterable {
    case name
    case photo
    case descripion
    case step
    
    func cellIdentifier(for indexPath: IndexPath) -> String {
        switch self {
        case .name:
            return indexPath.item == 0 ? "TitleCell" : "DescriptionCell"
        case .photo:
            return indexPath.item == 0 ? "TitleCell" : "ImageCell"
        case .descripion:
            return indexPath.item == 0 ? "TitleCell" : "DescriptionCell"
        case .step:
            return indexPath.item == 0 ? "TitleCell" : "DescriptionCell"
        }
    }
}
