//
//  ProductDetailTableViewCell.swift
//  HeadyEcommerce
//
//  Created by Roshan Soni on 12/01/19.
//  Copyright © 2019 Personal. All rights reserved.
//

import UIKit

protocol ProductDetailTableViewCellDelegate {
    func productBuy(productID:Int64,indexPath:IndexPath)
}


class ProductDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var lblColor: UILabel!
    @IBOutlet weak var lblSize: UILabel!
    @IBOutlet weak var btnBuy: UIButton!
    @IBOutlet weak var lblPrice: UILabel!
    
    var delegate:ProductDetailTableViewCellDelegate!
    var productId:Int64?
    var indexPath:IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func btnBuyPressed(_ sender: Any) {
        NetworkReachability.isUnreachable { (status) in
            Utility.sharedInstance.displayAlert(title: "No Internet connection", message: "No active internet connection found.Please connect to internet to purchase a product.")
        }
        NetworkReachability.isReachable { (status) in
            if self.delegate != nil {
                self.delegate.productBuy(productID: self.productId!, indexPath: self.indexPath!)
            }
        }
    }
}
