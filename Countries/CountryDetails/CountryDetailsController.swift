//
//  CountryDetailsController.swift
//  Countries
//
//  Created by Sujith Antony on 05/02/19.
//  Copyright © 2019 Sujith Antony. All rights reserved.
//

import UIKit

class CountryDetailsController: UIViewController {
    @IBOutlet weak var presenter:CountryDetailsPresenter!
     @IBOutlet weak var tableView:UITableView!
     @IBOutlet weak var imageView:UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.presenter?.currentCountry?.name
        self.imageView.image = self.presenter?.currentCountry?.flagImage
        let rightButtonItem = UIBarButtonItem.init(
            title: "Save",
            style: .done,
            target: self,
            action: #selector(saveButtonPressed(sender:))
        )
        self.navigationItem.rightBarButtonItem = rightButtonItem
        if Connectivity.isConnectedToInternet {
             rightButtonItem.isEnabled = true
        }
        else{
            rightButtonItem.isEnabled = false
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        let frame = self.view.frame.offsetBy(dx: 0, dy: -20)
        self.view.frame = frame
    }
    
    @objc func saveButtonPressed(sender: UIBarButtonItem){
        self.presenter.saveCurrentCountryInDB()
    }


}
