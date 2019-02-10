//
//  CountryDetailsPresenter.swift
//  Countries
//
//  Created by Sujith Antony on 05/02/19.
//  Copyright © 2019 Sujith Antony. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CountryDetailsPresenter:NSObject{
    var currentCountry:Country!
    var tableData:[(String,String)] = [("capital","Capital"),("callingCode","Calling Code"),("region","Region"),("subregion","Sub Region"),("timeZone","Time Zone"),("currency","Currencies"),("languages","Languages")]
    override init(){
        super.init()
    }
}

extension CountryDetailsPresenter:UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DetailCell = tableView.dequeueReusableCell(withIdentifier: detailCellIdentifier, for:indexPath) as! DetailCell
        if let country = currentCountry{
            let tuple = tableData[indexPath.row]
            let parameter = tuple.0
            let label = tuple.1
            cell.titleLabel.text = label
            switch indexPath.row{
            case 1,4:
                if let arrayOfValues:[String] = country[parameter] as? [String] {
                    let formattedString = arrayOfValues.map{String($0)}.joined(separator: ",")
                    cell.detailLabel.text = formattedString
                }
            case 5,6:
                if let arrayOfValues:[[String:String]] = country[parameter] as? [[String:String]]{
                    let formattedString = arrayOfValues.map{$0["name"] ?? ""}.joined(separator: ",")
                    cell.detailLabel.text = formattedString
                }
                
            default:
                cell.detailLabel.text = country[parameter] as? String
            }
            cell.selectionStyle = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
            return self.tableData.count
      
    }
    
    func saveCurrentCountryInDB(){
         if let country = currentCountry{
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appdelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "CountryEntity", in: context)
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CountryEntity")
            let predicate = NSPredicate(format:"name = %@",currentCountry.name)
            request.predicate = predicate
            do {
            let result = try context.fetch(request)
                if(result.count>0){
                    return
                }
                let newCountry = CountryEntity(entity: entity!, insertInto: context)
                newCountry.name = country.name
                newCountry.capital = country.capital
                newCountry.callingCode = country.callingCode
                newCountry.currencies = country.currency as? [[String : String]]
                newCountry.flagImage = country.flagImage?.pngData() as NSData?
                newCountry.flagImageURL = country.flagImageURL
                newCountry.region = country.region
                newCountry.subregion = country.subregion
                newCountry.languages = country.languages as? [[String : String]]
                newCountry.timeZones = country.timeZone
                do {
                    try context.save()
                    print ("saved")
                } catch {
                    print("Failed saving")
                }
                }
            catch {
                 print("Failed Loading Local Data")
            }
        }
    }
}
