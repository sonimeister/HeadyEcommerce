//
//  ProductRankingTableViewCell.swift
//  HeadyEcommerce
//
//  Created by Roshan Soni on 13/01/19.
//  Copyright © 2019 Personal. All rights reserved.
//

import UIKit

class ProductRankingTableViewCell: UITableViewCell {

    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblCount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
