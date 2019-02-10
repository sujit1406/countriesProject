//
//  CountryEntity+CoreDataProperties.swift
//  Countries
//
//  Created by Sujith Antony on 06/02/19.
//  Copyright © 2019 Sujith Antony. All rights reserved.
//
//

import Foundation
import CoreData


extension CountryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CountryEntity> {
        return NSFetchRequest<CountryEntity>(entityName: "CountryEntity")
    }

    @NSManaged public var callingCode:  [String]?
    @NSManaged public var capital: String?
    @NSManaged public var currencies: [[String:String]]?
    @NSManaged public var flagImage: NSData?
    @NSManaged public var flagImageURL: String?
    @NSManaged public var languages: [[String:String]]?
    @NSManaged public var name: String?
    @NSManaged public var region: String?
    @NSManaged public var subregion: String?
    @NSManaged public var timeZones: [String]?

}
