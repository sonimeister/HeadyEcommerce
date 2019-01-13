//
//  ProductRankingViewController.swift
//  HeadyEcommerce
//
//  Created by Roshan Soni on 12/01/19.
//  Copyright © 2019 Personal. All rights reserved.
//

import UIKit
import CoreData

class ProductRankingViewController: UIViewController {

    @IBOutlet weak var segmentRanking: UISegmentedControl!
    @IBOutlet weak var tblView: UITableView!
    
    lazy var productMostViewResults: NSFetchedResultsController<Product> = {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: PRODUCT_RANKING.view_count.rawValue, ascending: false)]
        
        let resultsController = NSFetchedResultsController<Product>(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance.privateContext, sectionNameKeyPath: nil, cacheName: nil)
        resultsController.delegate = self
        return resultsController
    }()
    
    lazy var productMostSharedResults: NSFetchedResultsController<Product> = {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: PRODUCT_RANKING.shares.rawValue, ascending: false)]
        let resultsController = NSFetchedResultsController<Product>(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance.privateContext, sectionNameKeyPath: nil, cacheName: nil)
        resultsController.delegate = self
        return resultsController
    }()
    
    lazy var productMostOrderedResults: NSFetchedResultsController<Product> = {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: PRODUCT_RANKING.order_count.rawValue, ascending: false)]
        
        let resultsController = NSFetchedResultsController<Product>(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance.privateContext, sectionNameKeyPath: nil, cacheName: nil)
        resultsController.delegate = self
        return resultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchProductsRanking()
    }
    
    @IBAction func segmentRankingValueChanges(_ sender: Any) {
        self.fetchProductsRanking()
        tblView.reloadData()
    }
    
    func fetchProductsRanking () {
        do {
            if segmentRanking.selectedSegmentIndex == 0 {
                try productMostViewResults.performFetch()
            }
            else if segmentRanking.selectedSegmentIndex == 1 {
                try productMostSharedResults.performFetch()
            }
            else {
                try productMostOrderedResults.performFetch()
            }
            
        } catch {
            print("Unable to fetch Data \(error)")
        }
    }
    
    func segueToProductDetailViewController(product: Product) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "productDetail") as! ProductViewController
        vc.product = product
        vc.title = product.name
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func configureProductRankingCell(_ cell: ProductRankingTableViewCell, indexPath: IndexPath) {
        if segmentRanking.selectedSegmentIndex == 0 {
            let category = productMostViewResults.object(at: indexPath)
            cell.lblProductName.text = category.name
            cell.lblCount.text = "\(category.viewCount)"
        }
        else if segmentRanking.selectedSegmentIndex == 1 {
            let category = productMostSharedResults.object(at: indexPath)
            cell.lblProductName.text = category.name
            cell.lblCount.text = "\(category.sharedCount)"
        }
        else {
            let category = productMostOrderedResults.object(at: indexPath)
            cell.lblProductName.text = category.name
            cell.lblCount.text = "\(category.orderedCount)"
        }
    }
}

extension  ProductRankingViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentRanking.selectedSegmentIndex == 0 {
            if let sections = productMostViewResults.sections {
                let currentSection = sections[section]
                return currentSection.numberOfObjects
            }
        }
        else if segmentRanking.selectedSegmentIndex == 1 {
            if let sections = productMostSharedResults.sections {
                let currentSection = sections[section]
                return currentSection.numberOfObjects
            }
        }
        else {
            if let sections = productMostOrderedResults.sections {
                let currentSection = sections[section]
                return currentSection.numberOfObjects
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productRankingCellIdentifier", for: indexPath) as! ProductRankingTableViewCell
        self.configureProductRankingCell(cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segmentRanking.selectedSegmentIndex == 0 {
            let product = productMostViewResults.object(at: indexPath)
            segueToProductDetailViewController(product: product)
        }
        else if segmentRanking.selectedSegmentIndex == 1 {
            let product = productMostSharedResults.object(at: indexPath)
            segueToProductDetailViewController(product: product)
        }
        else {
            let product = productMostOrderedResults.object(at: indexPath)
            segueToProductDetailViewController(product: product)
        }
    }
}


// MARK: - NSFetchedResultsControllerDelegate
extension ProductRankingViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tblView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tblView.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                tblView.deleteRows(at: [indexPath], with: .fade)
            }
            break;
        case .update:
            if let indexPath = indexPath {
                if let cell = tblView.cellForRow(at: indexPath) {
                    configureProductRankingCell(cell as! ProductRankingTableViewCell, indexPath: indexPath)
                }
            }
            break;
        case .move:
            if let indexPath = indexPath {
                tblView.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let newIndexPath = newIndexPath {
                tblView.insertRows(at: [newIndexPath], with: .fade)
            }
            break;
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tblView.endUpdates()
    }
}

