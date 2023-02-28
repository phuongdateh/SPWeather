//
//  CityInfo+CoreDataClass.swift
//  SPWeather
//
//  Created by James on 28/02/2023.
//

import Foundation
import CoreData

@objc(CityInfo)
class CityInfo: NSManagedObject {}

extension CityInfo {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CityInfo> {
        return NSFetchRequest<CityInfo>(entityName: "CityInfo")
    }

    @NSManaged public var name: String?
    @NSManaged public var createdAt: Date?
}
