//
//  OnlineSearchController.swift
//  Countries
//
//  Created by Sujith Antony on 05/02/19.
//  Copyright © 2019 Sujith Antony. All rights reserved.
//

import UIKit

class OnlineSearchController: UIViewController{
    
    @IBOutlet weak var presenter:OnlineSearchPresenter!
    @IBOutlet weak var tableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.delegate = self
        self.tableView.delegate = self
        self.presenter.searchController.isActive = false;
        self.navigationItem.titleView = self.presenter.searchController.searchBar
        self.presenter.searchController.searchBar.accessibilityIdentifier = "search-bar"
        NotificationCenter.default.addObserver(self, selector: #selector(networkstatuschanged), name: Notification.Name("NetworkChanged"), object: nil)
        if(!Connectivity.isConnectedToInternet){
             self.presenter.loadSavedCountries()
        }
       
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "details",
            let nextScene = segue.destination as? CountryDetailsController ,
            let indexPath = self.tableView.indexPathForSelectedRow {
            var selectedCountry:Country? = nil
            selectedCountry = self.presenter.filteredTableData?[indexPath.row] as Country?
            nextScene.presenter.currentCountry = selectedCountry
        }
    }
    @objc func networkstatuschanged(){
        self.didFinishLoadingResults()
    }
}
extension  OnlineSearchController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "details", sender: self)
    }
}



extension OnlineSearchController:SearchResultsProtocol{
    func didFinishLoadingResults() {
        self.tableView.reloadData()
    }
    

}

extension OnlineSearchController:UISearchBarDelegate{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        self.presenter.searchController.isActive = false;
    }
}




