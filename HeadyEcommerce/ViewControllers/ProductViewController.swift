//
//  ProductViewController.swift
//  HeadyEcommerce
//
//  Created by Roshan Soni on 06/01/19.
//  Copyright © 2019 Personal. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController {
    
    @IBOutlet weak var lblProductName: UILabel!
    var product:Product?
    var varients = [Varient]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        varients = product?.varients?.allObjects as! [Varient]
    }

}


extension ProductViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return varients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productDetailCellIdentifier", for: indexPath) as! ProductDetailTableViewCell
        cell.lblColor.text = varients[indexPath.row].color
        cell.lblSize.text = varients[indexPath.row].size > 0 ? "\(varients[indexPath.row].size)" : ""
        cell.lblPrice.text = "\(varients[indexPath.row].price)"
        cell.productId = self.product?.id
        cell.indexPath = indexPath
        cell.delegate = self
        return cell
    }
}


extension ProductViewController:ProductDetailTableViewCellDelegate {
    func productBuy(productID: Int64, indexPath: IndexPath) {
        let alert = UIAlertController(title: "Purchase Product", message: "Are sure want to purchase this product?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("product purchased")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
        self.present(alert, animated: true, completion: nil)
    }
}
