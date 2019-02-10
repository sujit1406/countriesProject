//
//  OnlineSearchPresenter.swift
//  Countries
//
//  Created by Sujith Antony on 05/02/19.
//  Copyright © 2019 Sujith Antony. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import CoreData
import SVGKit
protocol SearchResultsProtocol:class{
    func didFinishLoadingResults()
}
let imageCache = NSCache<AnyObject, AnyObject>()

class OnlineSearchPresenter:NSObject,UISearchControllerDelegate{
    var filteredTableData :[Country]?
    var localTableData :[Country]?
    weak var delegate:SearchResultsProtocol?
    @IBOutlet var searchController:UISearchController! = UISearchController(searchResultsController: nil)
    override init(){
        super.init()
        self.searchController.searchResultsUpdater = self
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = true
        self.searchController.searchBar.placeholder = "Search Countries"
        self.searchController.searchBar.sizeToFit()
    }
    
    
    
    func searchCountriesWithKeyWord(key:String,completion:@escaping ()->Void){
        if Connectivity.isConnectedToInternet {
            self.performOnlineSearch(key: key) {
                self.delegate?.didFinishLoadingResults()
                completion()
            }
        }else{
            self.performOfflineSearch(key: key) {
                 self.delegate?.didFinishLoadingResults()
                  completion()
            }
        }
    }
    
    
    func performOnlineSearch(key:String,completion:@escaping ()->Void){
        APIClient.getCountriesList(keyword: key) { countries in
            if let list = countries.value{
                self.filteredTableData?.removeAll()
                self.filteredTableData = nil
                self.filteredTableData = list
                completion()
            }
        }
    }
    
    
    func performOfflineSearch(key:String,completion:@escaping ()->Void){
        
        if(key.count == 0){
           self.filteredTableData = self.localTableData
            completion()
        }
        else{
        let results = self.localTableData?.filter{
            $0.name.localizedCaseInsensitiveContains(key)
        }
        self.filteredTableData?.removeAll()
        self.filteredTableData = nil
        self.filteredTableData = results
            completion()
            
        }
    }
    
    func getSVGImage(url:String?,completion:@escaping (UIImage?)->Void){

        if let flagurlstring = url,flagurlstring.count>0{
            
            DispatchQueue(label: "flagQueue", attributes: .concurrent).async(execute: { () -> Void in
                do{
                    APIClient.getFlag(url: flagurlstring) { (data) in
                        let image = SVGKImage.init(data: data)
                        DispatchQueue.main.async {
                            completion(image?.uiImage)}
                    }
                }catch { print("Could not load URL: \(url): \(error)") }
            })

            
        }
        }
    
    func loadSavedCountries(){
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CountryEntity")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            self.localTableData?.removeAll()
            self.localTableData = nil
            self.localTableData = [Country]()
            for data in result as! [CountryEntity] {
                print(data.value(forKey: "name") as! String)
                let country:Country = Country()
                country.name = data.name!
                country.capital = data.capital!
                country.callingCode = data.callingCode
                country.currency = data.currencies
                country.flagImage = UIImage.init(data:data.flagImage! as Data)
                country.flagImageURL = data.flagImageURL
                country.region = data.region
                country.subregion = data.subregion
                country.languages = data.languages
                country.timeZone = data.timeZones
                self.localTableData?.append(country)
            }
            self.filteredTableData = self.localTableData
            self.delegate?.didFinishLoadingResults()
            
        } catch {
            print("Failed Loading Local Data")
        }
    }


}

extension OnlineSearchPresenter:UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CountryCell = tableView.dequeueReusableCell(withIdentifier: countryCellIdentifier, for:indexPath) as! CountryCell
        
        var country:Country? = nil
           country = filteredTableData?[indexPath.row]
        if let country = country{
        cell.countryNameLabel.text = country.name

            
        if let flagurl = country.flagImageURL{
            if let imageFromCache = imageCache.object(forKey: flagurl as AnyObject) as? UIImage {
                cell.flagView?.image = imageFromCache
                country.flagImage = imageFromCache
            }
            else{
                self.getSVGImage(url: flagurl, completion: { (image) in
                    if let img = image{
                        imageCache.setObject(img, forKey: flagurl as AnyObject)
                        cell.flagView?.image = image
                        country.flagImage = image
                    }
                    
                })
               
                
            }
           
        }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredTableData?.count ?? 0
    }

}


extension  OnlineSearchPresenter:UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {        
        if let key = searchController.searchBar.text{
                self.searchCountriesWithKeyWord(key: key){
            }
    }
    }
}
