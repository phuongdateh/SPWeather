//
//  CoreDataManager.swift
//  SPWeather
//
//  Created by James on 28/02/2023.
//

import Foundation
import CoreData

protocol CoreDataManagerInterface {
    func registerObjectContextDidSave(action: @escaping VoidAction)
    func save()
    func updateCity(with name: String)
    func insertCityItem(name: String) -> CityInfo?
    func fetchCity(with name: String) -> CityInfo?
    func fetchCityList() -> [CityInfo]
}

final class CoreDataManager: CoreDataManagerInterface {
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
    }

    func registerObjectContextDidSave(action: @escaping VoidAction) {
        let nc = NotificationCenter.default
        nc.addObserver(forName: NSNotification.Name.NSManagedObjectContextDidSave,
                       object: self.persistentContainer.viewContext, queue: nil) { _ in
            action()
        }
    }

    func notifyObjectContextDidSave() {
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: CustomNotificationName.managedObjectContextDidSave.rawValue),
            object: nil
        )
    }

    lazy var backgroundContext: NSManagedObjectContext = {
        return self.persistentContainer.newBackgroundContext()
    }()

    func save() {
        if backgroundContext.hasChanges {
            try! backgroundContext.save()
        }
    }
    
    func insertCityItem(name: String) -> CityInfo? {
        let cityItem = NSEntityDescription.insertNewObject(forEntityName: Entities.cityInfo.rawValue,
                                                           into: self.backgroundContext) as? CityInfo
        cityItem?.name = name
        cityItem?.createdAt = Date()
        return cityItem
    }

    func updateCity(with name: String) {
        let request: NSFetchRequest<CityInfo> = CityInfo.fetchRequest()
        request.predicate = NSPredicate(format: "name LIKE %@", name)
        let cityList = try? self.persistentContainer.viewContext.fetch(request)
        let firstCity = cityList?.first
        firstCity?.createdAt = Date()
        try! self.persistentContainer.viewContext.save()
    }

    func fetchCityList() -> [CityInfo] {
        let request: NSFetchRequest<CityInfo> = CityInfo.fetchRequest()
        request.fetchLimit = 10
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        return try! persistentContainer.viewContext.fetch(request)
    }

    func fetchCity(with name: String) -> CityInfo? {
        let request: NSFetchRequest<CityInfo> = CityInfo.fetchRequest()
        request.predicate = NSPredicate(format: "name LIKE %@", name)
        return try? self.persistentContainer.viewContext.fetch(request).first
    }

    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
                                                  object: self.persistentContainer.viewContext)
    }
}
