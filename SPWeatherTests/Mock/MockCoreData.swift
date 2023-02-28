//
//  MockCoreData.swift
//  SPWeatherTests
//
//  Created by James on 28/02/2023.
//

import Foundation
import XCTest
import CoreData
@testable import SPWeather

final class MockCoreData {
    let xctTestCase: XCTestCase
    
    init(xctTestCase: XCTestCase) {
        self.xctTestCase = xctTestCase
    }
    
    // MARK: - Mock in-memory persistant store
    private func getManagedObjectModel() -> NSManagedObjectModel {
        return NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self.xctTestCase))])!
    }
    
    func getMockPersistantContainer() -> NSPersistentContainer {
        let container = NSPersistentContainer(name: "SPWeather",
                                              managedObjectModel: self.getManagedObjectModel())
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            precondition( description.type == NSInMemoryStoreType )
            if let error = error {
                fatalError("Create an in-mem coordinator failed \(error)")
            }
        }
        return container
    }
    
    func flushDataInCoreData() {
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: Entities.cityInfo.rawValue)
        let objs = try! self.getMockPersistantContainer().viewContext.fetch(fetchRequest)
        for case let obj as NSManagedObject in objs {
            self.getMockPersistantContainer().viewContext.delete(obj)
        }
        try! self.getMockPersistantContainer().viewContext.save()
    }
}
