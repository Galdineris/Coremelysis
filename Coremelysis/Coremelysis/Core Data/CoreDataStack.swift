//
//  CoreDataStack.swift
//  Coremelysis
//
//  Created by Artur Carneiro on 27/09/20.
//  Copyright © 2020 Rafael Galdino. All rights reserved.
//

import CoreData

/// Object responsible for initializing the Core Data stack and provide access to the main context
/// through a computed variable.
final class CoreDataStack {
    // - MARK: Properties
    /// The model's name. It has a default value of `Coremelysis`.
    private let model: String

    /// The container lazily initialized. It sets the main context with the
    /// `automaticallyMergesChangesFromParent` property as true.
    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.model)
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent store: \(error.localizedDescription)")
            }

            container.viewContext.automaticallyMergesChangesFromParent = true
        }

        return container
    }()

    /// A computed variable that gives access to the container's `viewContext` property.
    /// As this context is set to work on the main thread it should be used for UI-related tasks.
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }

    // - MARK: Init
    /// Initializes a new instance of this type.
    /// - Parameter model: The model's name. It has a default value of `Coremelysis`.
    init(model: String = "Coremelysis") {
        self.model = model
    }

    /// Saves any changes in the main context. If no changes have been made, nothing will happen.
    func save() throws {
        if mainContext.hasChanges {
            try mainContext.save()
        } else {

        }
    }

    private enum Errors: Error, CustomStringConvertible {
        case failedToSave
        var description: String {
            switch self {
            case .failedToSave:
                return "Failed to save changes to the device"
            }
        }
    }
}
