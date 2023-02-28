//
//  CoreDataManager.swift
//  SPWeather
//
//  Created by James on 28/02/2023.
//

import Foundation
import CoreData

final class CoreDataManager {
    var persistentContainer: NSPersistentContainer!
    
    init(container: NSPersistentContainer) {
        self.persistentContainer = container
        self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    convenience init() {
        let container: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "SPWeather")
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in })
            return container
        }()
        self.init(container: container)
        let nc = NotificationCenter.default
        nc.addObserver(forName: NSNotification.Name.NSManagedObjectContextDidSave, object: self.persistentContainer.viewContext, queue: nil) { _ in
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: CustomNotificationName.managedObjectContextDidSave.rawValue),
                object: nil
            )
        }
    }
    
    
    lazy var backgroundContext: NSManagedObjectContext = {
        return self.persistentContainer.newBackgroundContext()
    }()
    
    
    func save() {
        if backgroundContext.hasChanges {
            do {
                try backgroundContext.save()
            } catch {
                print("Save error \(error)")
            }
        }
    }
    
    func insertCityItem(name: String) -> CityInfo? {
        if let cityItem = NSEntityDescription.insertNewObject(forEntityName: Entities.cityInfo.rawValue, into: self.backgroundContext) as? CityInfo {
            cityItem.name = name
            cityItem.createdAt = Date()
            return cityItem
        }
        return nil
    }
    
    func updateCity(with name: String) {
        let request: NSFetchRequest<CityInfo> = CityInfo.fetchRequest()
        request.predicate = NSPredicate(format: "name LIKE %@", name)
        if let cityList = try? self.persistentContainer.viewContext.fetch(request), let firstCity = cityList.first {
            firstCity.createdAt = Date()
            do {
                try self.persistentContainer.viewContext.save()
            } catch {
                print("Save error: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchCityList() -> [CityInfo] {
        let request: NSFetchRequest<CityInfo> = CityInfo.fetchRequest()
        request.fetchLimit = 10
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        let results = try? persistentContainer.viewContext.fetch(request)
        return results ?? [CityInfo]()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
                                                  object: self.persistentContainer.viewContext)
    }
}
