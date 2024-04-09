//
//  AppDelegate.swift
//  NewRecipeBook
//
//  Created by DonHalab on 15.12.2023.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    lazy var persistentContainer: NSPersistentContainer = {
           let container = NSPersistentContainer(name: "RecipeDataModel")
           container.loadPersistentStores(completionHandler: { (storeDescription, error) in
               if let error = error as NSError? {
                   fatalError("Невозможно загрузить хранилище: \(error), \(error.userInfo)")
               } else {
                   print(storeDescription.url?.absoluteString ?? "")
               }
           })
           return container
       }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        StorageDataManager.shared.persistentContainer = self.persistentContainer
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options _: UIScene.ConnectionOptions) -> UISceneConfiguration {

        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_: UIApplication, didDiscardSceneSessions _: Set<UISceneSession>) {
  
    }
    
}
