//
//  CountryCellTableViewCell.swift
//  Countries
//
//  Created by Sujith Antony on 06/02/19.
//  Copyright © 2019 Sujith Antony. All rights reserved.
//

import UIKit
import WebKit
let countryCellIdentifier = "countryCell"
class CountryCell: UITableViewCell {

    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet  weak var flagView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}
