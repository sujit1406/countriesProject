//
//  DetailCell.swift
//  Countries
//
//  Created by Sujith Antony on 06/02/19.
//  Copyright © 2019 Sujith Antony. All rights reserved.
//

import UIKit
let detailCellIdentifier = "detailCell"
class DetailCell: UITableViewCell {
     @IBOutlet weak var titleLabel: UILabel!
     @IBOutlet weak var detailLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
