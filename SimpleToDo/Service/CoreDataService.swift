//
//  CoreDataService.swift
//  SimpleToDo
//
//  Created by ryo.tsuzukihashi on 2024/09/17.
//

import Foundation
import CoreData

protocol CoreDataServiceProtocol {
    func addItem(title: String) throws
    func updateItem(id: String, isComplete: Bool) throws
    func fetchAllItem() throws -> [Item]
    func fetchItem(id: String) throws -> Item?
    func deleteItem(id: String) throws
}

final class CoreDataService {
    var container: NSPersistentContainer
    private var context: NSManagedObjectContext {
        return container.viewContext
    }

    public static let shared: CoreDataService = .init()

    private init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "SimpleToDo")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    static var preview: CoreDataService = {
        let result = CoreDataService(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
}

extension CoreDataService: CoreDataServiceProtocol {
    func addItem(title: String) throws {
        let item = Item(context: context)
        item.id = UUID().uuidString
        item.timestamp = Date()
        item.isComplete = false
        item.title = title
        try context.save()
    }

    func updateItem(id: String, isComplete: Bool) throws {
        guard let item = try fetchItem(id: id) else { throw SampleError.missingItemID }
        item.timestamp = Date()
        item.isComplete = isComplete
        try context.save()
    }

    func fetchAllItem() throws -> [Item] {
        let request = NSFetchRequest<Item>(entityName: "Item")
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        let categories = try context.fetch(request)
        return categories
    }

    func fetchItem(id: String) throws -> Item? {
        let request = NSFetchRequest<Item>(entityName: "Item")
        request.predicate = NSPredicate(format: "id == %@", id)
        return try context.fetch(request).first
    }

    func deleteItem(id: String) throws {
        guard let item = try fetchItem(id: id) else { throw SampleError.missingItemID }
        context.delete(item)
        try context.save()
    }
}
