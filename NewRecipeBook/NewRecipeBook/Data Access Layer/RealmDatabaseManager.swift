//
//  RealmDatabaseManager.swift
//  NewRecipeBook
//
//  Created by DonHalab on 18.12.2023.
//

import Alamofire
import Foundation
import RealmSwift

class RealmRecipe: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String
    @Persisted var descript: String
    @Persisted var imageUrl: String
    @Persisted var ingredients: String
    @Persisted var steps: String
    @Persisted var imageData: Data?
}

class RealmDatabaseManager {
    private var realm: Realm {
        return try! Realm()
    }

    let imageDownloader = NetworkManager()
    

    func saveRecipesFromParser(_ parser: RecipeParserRealm = RecipeParserRealm()) {
        let dataBaseEntries = parser.parserInfo()

        do {
            try realm.write {
                for entry in dataBaseEntries {
                    if let existingRecipe = realm.objects(RealmRecipe.self).filter("imageUrl == %@", entry.imageUrl).first {
                        // Если запись существует, проверяем загружены ли данные изображения
                        if existingRecipe.imageData == nil {
                            imageDownloader.downloadImage(url: entry.imageUrl) { data in
                                try? self.realm.write {
                                    existingRecipe.imageData = data
                                }
                            }
                        }
                    } else {
                        // Если записи нет, создаём новую
                        let newRecipe = RealmRecipe()
                        newRecipe.name = entry.name
                        newRecipe.imageUrl = entry.imageUrl
                        newRecipe.ingredients = entry.ingredients
                        newRecipe.steps = entry.steps
                        newRecipe.descript = entry.description

                        imageDownloader.downloadImage(url: entry.imageUrl) { data in
                            try? self.realm.write {
                                newRecipe.imageData = data
                            }
                        }

                        realm.add(newRecipe)
                    }
                }
            }
        } catch {
            print("Ошибка при сохранении в Realm: \(error)")
        }
    }
}

extension RealmDatabaseManager {
    func loadRecipes() -> Results<RealmRecipe> {
            let realm = try! Realm()
            return realm.objects(RealmRecipe.self)
        }
}

extension RealmDatabaseManager {
    func deleteDataBase() {
        let realmURL = Realm.Configuration.defaultConfiguration.fileURL
        if let url = realmURL {
            do {
                try FileManager.default.removeItem(at: url)
                print("Старая база данных Realm успешно удалена.")
            } catch {
                print("Ошибка при удалении базы данных Realm: \(error)")
            }
        }
    }
}

extension RealmDatabaseManager {
    func updateRecipeName(recipe: RealmRecipe, with name: String) {
        let realm = try! Realm()
        try! realm.write {
            recipe.name = name
        }
    }
}

extension RealmDatabaseManager {
    func updateImages(recipe: RealmRecipe, newImageData: Data?) {
        let realm = try! Realm()
        try! realm.write {
            recipe.imageData = newImageData
        }
    }
}

extension RealmDatabaseManager {
    func updateRecipeDescription(recipe: RealmRecipe, with description: String) {
        let realm = try! Realm()
        try! realm.write {
            recipe.descript = description
        }
    }
}

extension RealmDatabaseManager {
    func updateRecipeSteps(recipe: RealmRecipe, with steps: String) {
        let realm = try! Realm()
        try! realm.write {
            recipe.steps = steps
        }
    }
}

extension RealmDatabaseManager {
    func filterRecipes(for searchText: String) -> Results<RealmRecipe> {
        let realm = try! Realm()
        return realm.objects(RealmRecipe.self).filter("name CONTAINS[c] %@", searchText)
    }
}
