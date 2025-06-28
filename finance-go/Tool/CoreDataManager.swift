//
//  CoreDataManager.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 6/28/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import CoreData

struct CoreDataManager {
    static let shared = CoreDataManager() // will live forever as long as your application is still alive, it's properties will too

    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModels")
        container.loadPersistentStores { _, err in
            if let err = err {
                fatalError("Loading of store failed: \(err)")
            }
        }
        return container
    }()

    func fetchWatchCompanies() -> [WatchCompany] {
        let context = persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<WatchCompany>(entityName: "WatchCompany")
        do {
            let myCompanies = try context.fetch(fetchRequest)
            return myCompanies
        } catch let fetchErr {
            print("Failed to fetch companies:", fetchErr)
            return []
        }
    }
}
