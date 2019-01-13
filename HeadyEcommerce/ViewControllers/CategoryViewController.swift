//
//  CategoryViewController.swift
//  HeadyEcommerce
//
//  Created by Roshan Soni on 06/01/19.
//  Copyright © 2019 Personal. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    
    var parentCategory: Category?
    var categoryTypes = TYPES.noCategory
    
    lazy var categoryResults: NSFetchedResultsController<Category> = {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        if let category = parentCategory  {
            fetchRequest.predicate = NSPredicate(format: "parentId == %@","\(category.id)")
        } else {
            fetchRequest.predicate = NSPredicate(format: "parentId == 0")
        }
        
        let resultsController = NSFetchedResultsController<Category>(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance.privateContext, sectionNameKeyPath: nil, cacheName: nil)
        resultsController.delegate = self
        return resultsController
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (parentCategory == nil) {
            self.fetchProdductsData()
        }
        do {
            try categoryResults.performFetch()
        } catch {
            print("Unable to fetch Data \(error)")
        }
    }
    
    func fetchProdductsData(){
        NetworkReachability.isReachable { (status) in
            CoreDataStack.sharedInstance.clearPersistence()
            Utility.sharedInstance.startLoading(onView: self.view)
            NetworkManager.sharedInstance.getDataFromServer(successBlock: { (jsonData) in
                guard let json = jsonData else {
                    return
                }
                DispatchQueue.main.async {
                    Category.insertJsonData(json: json as! jsonBase)
                }
            }, failureBlock: { (error) in
                Utility.sharedInstance.stopLoading()
            })
        }
        NetworkReachability.isUnreachable { (status) in
            print("Network not reachable")
        }
    }
    
    func pushToChildCategoryViewController(category: Category) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let childViewController = storyboard.instantiateViewController(withIdentifier: "productCategory") as! CategoryViewController
        childViewController.parentCategory = category
        navigationController?.pushViewController(childViewController, animated: true)
    }
    
    func pushToProductDetailViewController(product: Product) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let productDetailViewController = storyboard.instantiateViewController(withIdentifier: "productDetail") as! ProductViewController
        productDetailViewController.product = product
        productDetailViewController.title = product.name
        navigationController?.pushViewController(productDetailViewController, animated: true)
    }
    
}

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = categoryResults.sections {
            let section = sections[section]
            if section.numberOfObjects > 0 {
                categoryTypes = .category
                return section.numberOfObjects
            } else if let products = parentCategory?.products?.allObjects as? [Product], products.count > 0 {
                categoryTypes = .product
                return products.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCellIdentifier", for: indexPath) as! CategoryTableViewCell
        switch categoryTypes {
        case .category:
            configureCategoryCell(cell , indexPath: indexPath)
        case .product:
            configureProductCell(cell , indexPath: indexPath)
        default:
            print("Error occured no category found")
        }
        return cell
    }
    
    func configureCategoryCell(_ cell: CategoryTableViewCell, indexPath: IndexPath) {
        let category = categoryResults.object(at: indexPath)
        cell.lblCategoryName.text = category.name
    }
    
    func configureProductCell(_ cell: CategoryTableViewCell, indexPath: IndexPath) {
        guard let product = parentCategory?.products?.allObjects[indexPath.row] as? Product else { return }
        cell.lblCategoryName.text = product.name
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch categoryTypes {
        case .category:
            let category = categoryResults.object(at: indexPath)
            pushToChildCategoryViewController(category: category)
        case .product:
            guard let product = parentCategory?.products?.allObjects[indexPath.row] as? Product else { return }
            pushToProductDetailViewController(product: product)
        default:
            print("Error occured.")
        }
    }
}


// MARK: - NSFetchedResultsControllerDelegate
extension CategoryViewController: NSFetchedResultsControllerDelegate {
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
                    configureCategoryCell(cell as! CategoryTableViewCell, indexPath: indexPath)
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
