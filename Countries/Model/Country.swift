//
//  Country.swift
//  Countries
//
//  Created by Sujith Antony on 05/02/19.
//  Copyright © 2019 Sujith Antony. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage
class Country:NSObject,Decodable{
    var name:String = ""
    var capital:String = ""
    var callingCode:[String]? = []
    var region:String? = ""
    var subregion:String? = ""
    var timeZone:[String]? = []
    var currency:[[String:String?]]? = []
    var languages:[[String:String?]]? = []
    var flagImage:UIImage? = nil
    var flagImageURL:String? = ""
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case capital = "capital"
        case callingCode = "callingCodes"
        case region = "region"
        case subregion = "subregion"
        case timeZone = "timezones"
        case currency = "currencies"
        case languages = "languages"
        case flagImageURL = "flag"
    }
    
    override init() {
       
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        capital = try container.decode(String.self, forKey: .capital)
        callingCode = try container.decode(Array.self, forKey: .callingCode)
        region = try container.decode(String.self, forKey: .region)
         subregion = try container.decode(String.self, forKey: .subregion)
         timeZone = try container.decode([String].self, forKey: .timeZone)
         currency = try container.decode([[String:String?]].self, forKey: .currency)
         languages = try container.decode([[String:String?]].self, forKey: .languages)
        flagImageURL = try container.decode(String?.self, forKey: .flagImageURL)
    }
    
}

protocol PropertyReflectable { }

extension PropertyReflectable {
    subscript(key: String) -> Any? {
        let m = Mirror(reflecting: self)
        for child in m.children {
            if child.label == key { return child.value }
        }
        return nil
    }
}

extension Country: PropertyReflectable{
    
}
