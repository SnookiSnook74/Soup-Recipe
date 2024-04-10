//
//  SectionCollection.swift
//  Soup Recipe
//
//  Created by DonHalab on 10.04.2024.
//

import Foundation


enum Section: Int, CaseIterable  {
    case image
    case description
    case ingredients
    case steps
    
    
    var itemCount: Int {
        switch self {
        case .image: return 1
        case .description, .ingredients, .steps: return 2
        }
    }
    
    func cellIdentifier(for indexPath: IndexPath) -> String {
        switch self {
        case .image:
            return "ImageCollectionViewCell"
        case .description:
            return indexPath.item == 0 ? "TitleCollectionViewCell" : "TextCollectionViewCell"
        case .ingredients:
            return indexPath.item == 0 ? "TitleCollectionViewCell" : "TextCollectionViewCell"
        case .steps:
            return indexPath.item == 0 ? "TitleCollectionViewCell" : "TextCollectionViewCell"
        }
    }
}
