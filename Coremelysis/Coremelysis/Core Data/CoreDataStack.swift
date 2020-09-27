//
//  CoreDataStack.swift
//  Coremelysis
//
//  Created by Artur Carneiro on 27/09/20.
//  Copyright © 2020 Rafael Galdino. All rights reserved.
//

import CoreData

final class CoreDataStack {

    private let model: String

    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.model)
        let defaultURL = NSPersistentContainer.defaultDirectoryURL()
        let persistentDescription = NSPersistentStoreDescription(url: defaultURL)

        container.persistentStoreDescriptions = [persistentDescription]
        container.viewContext.automaticallyMergesChangesFromParent = true

        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent store")
            }
        }

        return container
    }()

    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }

    init(model: String) {
        self.model = model
    }

    func save() {
        if mainContext.hasChanges {
            do {

                try mainContext.save()
            } catch {
                // - TODO: Handle error
                print(error.localizedDescription)
            }
        }
    }
}
