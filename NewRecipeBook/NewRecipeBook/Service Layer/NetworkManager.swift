//
//  NetworkManager.swift
//  NewRecipeBook
//
//  Created by DonHalab on 18.12.2023.
//


import UIKit

/// Класс для похода в сеть
final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    /// Метод для получения UIImage по url
    /// - Parameters:
    /// - url: url нашего изображения
    /// - Returns: UIImage созданный с помощью URL
    func loadImage(url: String) async throws -> UIImage {
        guard let url = URL(string: url) else {
            throw NSError(domain: "Данного URL не существует", code: 1)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        guard let image = UIImage(data: data) else {
            throw NSError(domain: "Ошибка при загрузке изображения", code: 2)
        }
        return image
    }
}
