//
//  CoreDataManager.swift
//  StretchTimer
//
//  Created by Joseph Simeone on 7/9/21.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TeamSet")
        container.loadPersistentStores(completionHandler: { _, error in
            _ = error.map { fatalError("Pretty dang big error \($0)")}
        })
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func backgroundContext() -> NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
}
