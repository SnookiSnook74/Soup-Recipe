//
//  NetworkManager.swift
//  NewRecipeBook
//
//  Created by DonHalab on 18.12.2023.
//

import Alamofire
import Foundation

class NetworkManager {
    func downloadImage(url: String, completion: @escaping (Data?) -> Void) {
        AF.request(url).responseData { response in
            switch response.result {
            case let .success(data):
                completion(data)
            case let .failure(error):
                print("Ошибка загрузки изображения: \(error)")
                completion(nil)
            }
        }
    }
}
